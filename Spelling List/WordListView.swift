//
//  WordListView.swift
//  Spelling List
//
//  Created by YJ Soon on 30/1/25.
//

import SwiftUI
import SwiftData

struct WordListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var words: [WordItem]
    @State private var newWord = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section("Add New Word") {
                    TextField("Enter word", text: $newWord)
                        .onSubmit(addWord)
                }
                
                Section("Word List") {
                    ForEach(words) { word in
                        HStack {
                            Text(word.word)
                            Spacer()
                            Image(systemName: word.isStarred ? "star.fill" : "star")
                                .foregroundStyle(.yellow)
                                .onTapGesture { word.isStarred.toggle() }
                        }
                    }
                }
            }
            .navigationTitle("Spelling List")
            .toolbar {
                NavigationLink("Start Practice", destination: PracticeView())
            }
        }
    }
    
    private func addWord() {
        guard !newWord.isEmpty else { return }
        let item = WordItem(word: newWord)
        modelContext.insert(item)
        newWord = ""
    }
}

#Preview {
    WordListView()
        .modelContainer(for: WordItem.self, inMemory: true)
}
