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
                
                Button(isPaused ? "Resume" : "Pause") {
                    isPaused.toggle()
                    if !isPaused && !speechManager.isSpeaking {
                        speechManager.speak(words[currentIndex].word)
                    }
                }
                .buttonStyle(.borderedProminent)
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
            VStack(spacing: 40) {
                Text("You're done!")
                    .font(.largeTitle)
                Text(celebrationEmoji)
                    .font(.system(size: 100))
                Button("Dismiss") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .onAppear {
                if celebrationEmoji.isEmpty {
                    celebrationEmoji = celebrationEmojis.randomElement() ?? "🎉"
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
}

#Preview {
    PracticeView()
        .modelContainer(for: WordItem.self, inMemory: true)
}
