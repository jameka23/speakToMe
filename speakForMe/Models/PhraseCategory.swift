//
//  PhraseCategory.swift
//  speakForMe
//
//  Created by Jameka Echols on 6/14/26.
//

import Foundation

enum PhraseCategory: String, CaseIterable, Identifiable { // added identifiable for safer and easier list creations of enum
    case pain
    case food
    case water
    case bathroom
    case comfort
    case emergency
    case family

    var id: String { rawValue }

    var title: String {
        rawValue.capitalized
    }
}
