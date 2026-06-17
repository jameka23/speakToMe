//
//  Untitled.swift
//  speakForMe
//
//  Created by Jameka Echols on 6/16/26.
//

import XCTest
@testable import speakForMe

final class SentenceDraftTests: XCTestCase {

    func testTextIsEmptyWhenNoWordsAreAdded() {
        let draft = SentenceDraft()

        XCTAssertEqual(draft.text, "")
    }

    func testTextJoinsWordsWithSpaces() {
        let draft = SentenceDraft(words: ["I", "need", "water"])

        XCTAssertEqual(draft.text, "I need water")
    }

    func testAddingWordUpdatesText() {
        var draft = SentenceDraft()

        draft.words.append("Help")

        XCTAssertEqual(draft.text, "Help")
    }

    func testDeletingLastWordUpdatesText() {
        var draft = SentenceDraft(words: ["I", "need", "bathroom"])

        draft.words.removeLast()

        XCTAssertEqual(draft.text, "I need")
    }

    func testClearingWordsMakesTextEmpty() {
        var draft = SentenceDraft(words: ["I", "want", "family"])

        draft.words.removeAll()

        XCTAssertEqual(draft.text, "")
    }
}
