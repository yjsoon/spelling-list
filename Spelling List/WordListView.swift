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
    @State private var isShowingPractice = false
    
    enum SortType {
        case dateAdded
        case alphabetical
    }
    @State private var selectedSort: SortType = .dateAdded
    
    var sortedWords: [WordItem] {
        switch selectedSort {
        case .dateAdded:
            // Sort by the createdAt property so the earliest added words come first.
            return words.sorted { $0.createdAt < $1.createdAt }
        case .alphabetical:
            return words.sorted { $0.word.localizedCaseInsensitiveCompare($1.word) == .orderedAscending }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(sortedWords) { word in
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
                    Button(action: {
                        isShowingPractice = true
                    }) {
                        Image(systemName: "play.fill")
                    }
                    .disabled(words.isEmpty)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { isAddingWords = true }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Date Added") { selectedSort = .dateAdded }
                        Button("Alphabetical") { selectedSort = .alphabetical }
                    } label: {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                    }
                    .disabled(words.isEmpty)
                }
            }
            .sheet(isPresented: $isAddingWords) {
                AddWordsView()
            }
            .sheet(isPresented: $isShowingPractice) {
                PracticeView()
            }
        }
    }
    
}

#Preview {
    WordListView()
        .modelContainer(for: WordItem.self, inMemory: true)
}
