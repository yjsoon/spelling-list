//
//  ContentView.swift
//  Spelling List
//
//  Created by YJ Soon on 30/1/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            WordListView()
                .tabItem {
                    Label("Words", systemImage: "list.bullet")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: WordItem.self, inMemory: true)
}
