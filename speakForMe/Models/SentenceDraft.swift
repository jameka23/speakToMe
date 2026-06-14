//
//  SentenceDraft.swift
//  speakForMe
//
//  Created by Jameka Echols on 6/14/26.
//

import Foundation

struct SentenceDraft {
    var words: [String] = []

    var text: String {
        words.joined(separator: " ")
    }
}
