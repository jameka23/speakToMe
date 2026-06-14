//
//  PhraseStore.swift
//  speakForMe
//
//  Created by Jameka Echols on 6/14/26.
//

import Foundation
import SwiftData

@MainActor
final class PhraseStore {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func savePhrase(_ text: String) {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedText.isEmpty else { return }

        let phrase = Phrase(
            text: trimmedText,
            useCount: 1
        )

        modelContext.insert(phrase)
        saveChanges()
    }

    func deletePhrase(_ phrase: Phrase) {
        modelContext.delete(phrase)
        saveChanges()
    }

    func markPhraseUsed(_ phrase: Phrase) {
        phrase.useCount += 1
        phrase.lastUsedAt = .now
        saveChanges()
    }

    func toggleFavorite(_ phrase: Phrase) {
        phrase.isFavorite.toggle()
        saveChanges()
    }
    
    func saveChanges() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save phrase changes: \(error)")
        }
    }
}
