//
//  PhraseTests.swift
//  speakForMe
//
//  Created by Jameka Echols on 6/18/26.
//

import XCTest
@testable import speakForMe

final class PhraseTests: XCTestCase {

    func testPhraseInitializesWithText() {
        let phrase = Phrase(text: "I need water")

        XCTAssertEqual(phrase.text, "I need water")
        XCTAssertEqual(phrase.useCount, 1)
        XCTAssertFalse(phrase.isFavorite)
    }

    func testPhraseCanBeFavorited() {
        let phrase = Phrase(text: "I need help")

        phrase.isFavorite = true

        XCTAssertTrue(phrase.isFavorite)
    }

    func testPhraseUseCountCanIncrease() {
        let phrase = Phrase(text: "I need bathroom")

        phrase.useCount += 1

        XCTAssertEqual(phrase.useCount, 2)
    }

    func testPhraseLastUsedDateCanUpdate() {
        let phrase = Phrase(text: "I want food")
        let newDate = Date()

        phrase.lastUsedAt = newDate

        XCTAssertEqual(phrase.lastUsedAt, newDate)
    }
}
