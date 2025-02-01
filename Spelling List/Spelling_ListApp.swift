//
//  Spelling_ListApp.swift
//  Spelling List
//
//  Created by YJ Soon on 30/1/25.
//

import SwiftUI
import SwiftData

@main
struct Spelling_ListApp: App {

    init() {
        // Register default value for timePerWord
        UserDefaults.standard.register(defaults: ["timePerWord": 3])
    }


    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: WordItem.self)
    }
}
