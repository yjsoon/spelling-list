import SwiftUI 
import SwiftData

struct AddWordsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var existingWords: [WordItem]
    @State private var wordList = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                TextEditor(text: $wordList)
                    .font(.body)
                    .padding()
                    .focused($isTextFieldFocused)
                
                Text("Enter each word on a new line")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
            .navigationTitle("Add Words")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addWords()
                        dismiss()
                    }
                }
            }
            .onAppear {
                isTextFieldFocused = true
            }
        }
    }
    
    private func addWords() {
        let existingWordSet = Set(existingWords.map { $0.word.lowercased() })
        
        let newWords = wordList
            .split(separator: "\n")
            .map { String($0).trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .map { word -> (lowercased: String, titlecased: String) in
                (word.lowercased(), word.capitalized)
            }
        
        for word in newWords {
            if !existingWordSet.contains(word.lowercased) {
                let item = WordItem(word: word.titlecased)
                modelContext.insert(item)
            }
        }
    }
}
