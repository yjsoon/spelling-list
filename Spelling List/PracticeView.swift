//
//  PracticeSessionView.swift
//  Spelling List
//
//  Created by YJ Soon on 30/1/25.
//

import SwiftUI
import SwiftData

struct PracticeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var words: [WordItem]
    
    // Use AppStorage to retrieve the time per word setting
    @AppStorage("timePerWord") private var timePerWord: Int = 3
    
    @State private var currentIndex = 0
    @State private var timeRemaining = 3
    @State private var isPaused = false
    @State private var speechManager = SpeechManager()
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var celebrationEmoji: String = ""
    
    // List of possible celebration emojis.
    private let celebrationEmojis = ["🎉", "🥳", "🎊", "👏", "🪅"]
    
    // Using UUIDs for selection; WordItem has an auto-synthesized 'id'
    @State private var selectedWordIDs: Set<UUID> = []
    
    var body: some View {
        if currentIndex < words.count {
            VStack {
                Text("Word \(currentIndex + 1) of \(words.count)")
                    .font(.largeTitle)
                    .padding()
                
                Text("Time remaining: \(timeRemaining)s")
                    .font(.title)
                    .onReceive(timer) { _ in
                        guard !isPaused else { return }
                        if timeRemaining > 0 {
                            timeRemaining -= 1
                        } else {
                            nextWord()
                        }
                    }
                
                Group {
                    Button(isPaused ? "Resume" : "Pause") {
                        isPaused.toggle()
                        if !isPaused && !speechManager.isSpeaking {
                            speechManager.speak(words[currentIndex].word)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(isPaused ? .green : .gray)
                    
                    Button("Again?") {
                        speechManager.speak(words[currentIndex].word)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
            .onAppear {
                timeRemaining = timePerWord
                speechManager.speak(words[currentIndex].word)
            }
            .onDisappear {
                speechManager.stop()
            }
        } else {
            // Instead of a simple dismissal view, show a multi-select list of words for mistakes.
            NavigationView {
                List(words, id: \.id, selection: $selectedWordIDs) { word in
                    Text(word.word)
                }
                .environment(\.editMode, .constant(.active))
                .navigationTitle("Any mistakes?")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            updateMistakesAndDismiss()
                        }
                    }
                }
            }
        }
    }
    
    private func nextWord() {
        if currentIndex < words.count - 1 {
            currentIndex += 1
            timeRemaining = timePerWord
            speechManager.speak(words[currentIndex].word)
        } else {
            currentIndex = words.count
            timer.upstream.connect().cancel()
        }
    }
    
    private func updateMistakesAndDismiss() {
        for word in words {
            if selectedWordIDs.contains(word.id) {
                word.mistakeCount += 1
            }
        }
        dismiss()
    }
}

#Preview {
    PracticeView()
        .modelContainer(for: WordItem.self, inMemory: true)
}
