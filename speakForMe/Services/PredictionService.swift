import Foundation

struct PredictionService {
    
    func predict(for draft: SentenceDraft, savedPhrases: [Phrase] = []) -> PredictionResult {
        let savedSuggestions = suggestionsFromSavedPhrases(
            draftWords: draft.words,
            savedPhrases: savedPhrases
        )
        
        let ruleBasedSuggestions = suggestions(after: draft.words.last)
        
        let mergedSuggestions = mergeSuggestions(
            savedSuggestions,
            ruleBasedSuggestions
        )
        
        return PredictionResult(suggestions: mergedSuggestions)
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
    
    private func suggestionsFromSavedPhrases( draftWords: [String], savedPhrases: [Phrase]) -> [WordOption] {
        
        let normalizedDraftWords = draftWords.map { $0.lowercased() }
        
        let matchingPhrases = savedPhrases
            .sorted {
                if $0.isFavorite != $1.isFavorite {
                    return $0.isFavorite && !$1.isFavorite
                }
                
                if $0.useCount != $1.useCount {
                    return $0.useCount > $1.useCount
                }
                
                return $0.lastUsedAt > $1.lastUsedAt
            }
        
        var suggestions: [WordOption] = []
        
        for phrase in matchingPhrases {
            let phraseWords = phrase.text
                .split(separator: " ")
                .map { String($0).lowercased() }
            
            guard phraseWords.count > normalizedDraftWords.count else {
                continue
            }
            
            let phrasePrefix = Array(phraseWords.prefix(normalizedDraftWords.count))
            
            if phrasePrefix == normalizedDraftWords {
                let nextWord = phraseWords[normalizedDraftWords.count]
                suggestions.append(
                    WordOption(text: nextWord, category: .comfort)
                )
            }
        }
        
        return suggestions
    }
    
    private func mergeSuggestions(_ primary: [WordOption], _ fallback: [WordOption]) -> [WordOption] {
        var seenWords = Set<String>()
        var merged: [WordOption] = []
        
        for suggestion in primary + fallback {
            let key = suggestion.text.lowercased()
            
            guard !seenWords.contains(key) else {
                continue
            }
            
            seenWords.insert(key)
            merged.append(suggestion)
        }
        
        return Array(merged.prefix(8))
    }
}
