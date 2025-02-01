//
//  Item.swift
//  Spelling List
//
//  Created by YJ Soon on 30/1/25.
//

import Foundation
import SwiftData

@Model
class WordItem {
    var word: String
    var isStarred: Bool
    var isIncorrect: Bool
    var lastPracticed: Date
    var createdAt: Date
    
    init(word: String) {
        self.word = word
        self.isStarred = false
        self.isIncorrect = false
        self.lastPracticed = Date()
        self.createdAt = Date()
    }
}
