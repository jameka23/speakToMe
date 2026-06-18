//
//  PredictionServiceTests.swift
//  speakForMe
//
//  Created by Jameka Echols on 6/18/26.
//

import XCTest
@testable import speakForMe

final class PredictionServiceTests: XCTestCase {

    func testEmptyDraftReturnsStarterWords() {
        let service = PredictionService()
        let draft = SentenceDraft()

        let result = service.predict(for: draft)

        let suggestionTexts = result.suggestions.map { $0.text }

        XCTAssertEqual(suggestionTexts, [
            "I",
            "Need",
            "Want",
            "Help",
            "Pain",
            "Water",
            "Bathroom",
            "Family"
        ])
    }

    func testAfterIReturnsExpectedSuggestions() {
        let service = PredictionService()
        let draft = SentenceDraft(words: ["I"])

        let result = service.predict(for: draft)

        let suggestionTexts = result.suggestions.map { $0.text }

        XCTAssertEqual(suggestionTexts, [
            "need",
            "want",
            "feel",
            "am"
        ])
    }

    func testAfterNeedReturnsBasicNeedSuggestions() {
        let service = PredictionService()
        let draft = SentenceDraft(words: ["I", "need"])

        let result = service.predict(for: draft)

        let suggestionTexts = result.suggestions.map { $0.text }

        XCTAssertEqual(suggestionTexts, [
            "water",
            "food",
            "bathroom",
            "help",
            "family"
        ])
    }

    func testSavedPhraseCanSuggestNextWord() {
        let service = PredictionService()
        let draft = SentenceDraft(words: ["I"])

        let savedPhrase = Phrase(
            text: "I need water",
            useCount: 3,
            isFavorite: false
        )

        let result = service.predict(
            for: draft,
            savedPhrases: [savedPhrase]
        )

        let suggestionTexts = result.suggestions.map { $0.text }

        XCTAssertTrue(suggestionTexts.contains("need"))
    }

    func testSavedFavoritePhraseIsPrioritizedOverMoreUsedPhrase() {
        let service = PredictionService()
        let draft = SentenceDraft(words: ["I"])

        let favoritePhrase = Phrase(
            text: "I need help",
            useCount: 1,
            isFavorite: true
        )

        let moreUsedPhrase = Phrase(
            text: "I want water",
            useCount: 10,
            isFavorite: false
        )

        let result = service.predict(
            for: draft,
            savedPhrases: [moreUsedPhrase, favoritePhrase]
        )

        let firstSuggestion = result.suggestions.first?.text

        XCTAssertEqual(firstSuggestion, "need")
    }

    func testDuplicateSuggestionsAreRemoved() {
        let service = PredictionService()
        let draft = SentenceDraft(words: ["I"])

        let savedPhrase = Phrase(
            text: "I need water",
            useCount: 3,
            isFavorite: false
        )

        let result = service.predict(
            for: draft,
            savedPhrases: [savedPhrase]
        )

        let suggestionTexts = result.suggestions.map { $0.text.lowercased() }
        let uniqueSuggestionTexts = Set(suggestionTexts)

        XCTAssertEqual(suggestionTexts.count, uniqueSuggestionTexts.count)
    }

    func testSuggestionsAreLimitedToEight() {
        let service = PredictionService()
        let draft = SentenceDraft()

        let result = service.predict(for: draft)

        XCTAssertLessThanOrEqual(result.suggestions.count, 8)
    }
}
