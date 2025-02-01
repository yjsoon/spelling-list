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
    
    @State private var showAlert = false
    @State private var alertAction: AlertAction?
    
    enum AlertAction {
        case removeFavourites
        case clearAllWords
    }
    
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Remove Favourites") {
                            alertAction = .removeFavourites
                            showAlert = true
                        }
                        Button("Clear All Words") {
                            alertAction = .clearAllWords
                            showAlert = true
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
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
            .alert("Are you sure? This cannot be undone", isPresented: $showAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Confirm", role: .destructive) {
                    handleAlertAction()
                }
            }
        }
    }
    
    private func handleAlertAction() {
        guard let action = alertAction else { return }
        switch action {
        case .removeFavourites:
            for word in words where word.isStarred {
                word.isStarred = false
            }
            try? modelContext.save()
        case .clearAllWords:
            for word in words {
                modelContext.delete(word)
            }
            try? modelContext.save()
        }
    }
}

#Preview {
    WordListView()
        .modelContainer(for: WordItem.self, inMemory: true)
}
