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
    @Attribute(.unique)
    var id: UUID
    
    var text: String
    var createdAt: Date
    var lastUsedAt: Date
    var useCount: Int
    var isFavorite: Bool
    
    init(id: UUID = UUID(), text: String, createdAt: Date = .now, lastUsedAt: Date = .now, useCount: Int = 0, isFavorite: Bool = false) {
        self.id = id
        self.text = text
        self.createdAt = createdAt
        self.lastUsedAt = lastUsedAt
        self.useCount = useCount
        self.isFavorite = isFavorite
    }
}
