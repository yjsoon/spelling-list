import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var words: [WordItem]
    
    @State private var showAlert = false
    @State private var alertAction: AlertAction?
    
    enum AlertAction {
        case removeFavourites
        case clearAllWords
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Manage Words")) {
                    Button("Remove Favourites") {
                        alertAction = .removeFavourites
                        showAlert = true
                    }
                    Button("Clear All Words") {
                        alertAction = .clearAllWords
                        showAlert = true
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Are you sure? This cannot be undone.", isPresented: $showAlert) {
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
    SettingsView()
        .modelContainer(for: WordItem.self, inMemory: true)
}