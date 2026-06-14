//
//  Phrase.swift
//  speakForMe
//
//  Created by Jameka Echols on 6/14/26.
//

import Foundation
import SwiftData

@Model
class Phrase {
    var id: Int
    var text: String
    var createdAt: Date
    var lastUsedAt: Date
    var useCount: Int
    var category: String
    var isFavorite: Bool
    
    init(id: Int, text: String, createdAt: Date, lastUsedAt: Date, useCount: Int, category: String, isFavorte: Bool) {
        self.id = id
        self.text = text
        self.createdAt = createdAt
        self.lastUsedAt = lastUsedAt
        self.useCount = useCount
        self.category = category
        self.isFavorite = isFavorte
    }
}
