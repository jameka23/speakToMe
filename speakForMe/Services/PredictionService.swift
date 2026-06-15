//
//  PredictionService.swift
//  speakForMe
//
//  Created by Jameka Echols on 6/15/26.
//

import Foundation

struct PredictionService {
    
    func predict(for draft: SentenceDraft) -> PredictionResult {
        let suggestions = suggestions(after: draft.words.last)
        return PredictionResult(suggestions: suggestions)
    }
    
    func starterWords() -> [WordOption] {
        return [
            WordOption(text: "I", category: .comfort),
            WordOption(text: "Need", category: .comfort),
            WordOption(text: "Want", category: .comfort),
            WordOption(text: "Help", category: .emergency),
            WordOption(text: "Pain", category: .pain),
            WordOption(text: "Water", category: .water),
            WordOption(text: "Bathroom", category: .bathroom),
            WordOption(text: "Family", category: .family)
        ]
    }
    
    func suggestions(after word: String?) -> [WordOption] {
        guard let word = word?.lowercased() else {
            return starterWords()
        }
        
        switch word {
        case "i":
            return [
                WordOption(text: "need", category: .comfort),
                WordOption(text: "want", category: .comfort),
                WordOption(text: "feel", category: .comfort),
                WordOption(text: "am", category: .comfort)
            ]
            
        case "need":
            return [
                WordOption(text: "water", category: .water),
                WordOption(text: "food", category: .food),
                WordOption(text: "bathroom", category: .bathroom),
                WordOption(text: "help", category: .emergency),
                WordOption(text: "family", category: .family)
            ]
            
        case "want":
            return [
                WordOption(text: "water", category: .water),
                WordOption(text: "food", category: .food),
                WordOption(text: "blanket", category: .comfort),
                WordOption(text: "family", category: .family),
                WordOption(text: "help", category: .emergency)
            ]
            
        case "feel", "am":
            return [
                WordOption(text: "cold", category: .comfort),
                WordOption(text: "hot", category: .comfort),
                WordOption(text: "tired", category: .comfort),
                WordOption(text: "scared", category: .emergency),
                WordOption(text: "pain", category: .pain)
            ]
            
        case "pain":
            return [
                WordOption(text: "head", category: .pain),
                WordOption(text: "chest", category: .pain),
                WordOption(text: "stomach", category: .pain),
                WordOption(text: "back", category: .pain),
                WordOption(text: "legs", category: .pain)
            ]
            
        default:
            return starterWords()
        }
    }
}
