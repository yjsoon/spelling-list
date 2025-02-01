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
    @State private var isAddingWords = false
    
    var body: some View {
        NavigationStack {
            List {
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
            .navigationTitle("Spelling List")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink(destination: PracticeView()) {
                        Image(systemName: "play.fill")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { isAddingWords = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingWords) {
                AddWordsView()
            }
        }
    }
    
}

#Preview {
    WordListView()
        .modelContainer(for: WordItem.self, inMemory: true)
}
