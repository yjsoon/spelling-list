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
    @State private var isAscending = true
    
    var sortedWords: [WordItem] {
        let sorted = switch selectedSort {
        case .dateAdded:
            words.sorted { $0.createdAt < $1.createdAt }
        case .alphabetical:
            words.sorted { $0.word.localizedCaseInsensitiveCompare($1.word) == .orderedAscending }
        }
        return isAscending ? sorted : sorted.reversed()
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
                    Button {
                        isShowingPractice = true
                    } label: {
                        Image(systemName: "play.fill")
                    }
                    .disabled(words.isEmpty)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isAddingWords = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        SortOptionButton(
                            label: "Date Added",
                            sort: SortType.dateAdded,
                            selectedSort: $selectedSort,
                            isAscending: $isAscending
                        )
                        
                        SortOptionButton(
                            label: "Alphabetical",
                            sort: SortType.alphabetical,
                            selectedSort: $selectedSort,
                            isAscending: $isAscending
                        )
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
