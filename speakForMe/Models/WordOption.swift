//
//  WordOption.swift
//  speakForMe
//
//  Created by Jameka Echols on 6/14/26.
//

import Foundation

struct WordOption: Identifiable {
    let id = UUID()
    let text: String
    let category: PhraseCategory
}
