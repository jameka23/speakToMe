//
//  ContentView.swift
//  speakForMe
//
//  Created by Jameka Echols on 6/13/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    // adding model context
    @Environment(\.modelContext) private var modelContext
    
    @State private var speechService = SpeechService()
    @State private var draft = SentenceDraft()
    
    private let predictionService = PredictionService()
    
    private var predictionResult: PredictionResult {
        predictionService.predict(for: draft)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Text(draft.text.isEmpty ? "Build your sentence..." : draft.text)
                .font(.title2)
                .frame(maxWidth: .infinity, minHeight: 80)
                .padding()
                .background(.gray.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 120), spacing: 12)
                ],
                spacing: 12
            ) {
                ForEach(predictionResult.suggestions) { word in
                    Button(word.text) {
                        draft.words.append(word.text)
                    }
                    .font(.title3)
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .buttonStyle(.borderedProminent)
                }
            }
            
            HStack {
                Button("Delete") {
                    guard !draft.words.isEmpty else { return }
                    draft.words.removeLast()
                }
                .buttonStyle(.bordered)
                
                Button("Clear") {
                    draft.words.removeAll()
                }
                .buttonStyle(.bordered)
                
                Button("Speak") {
                    speakAndSave()
                }
                .buttonStyle(.borderedProminent)
                .disabled(draft.text.isEmpty)
            }
        }
        .padding()
    }
    
    /// This method saves the sentence that is spoken into history once a user hits the 'Speak' button
    private func speakAndSave() {
        let text = draft.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !text.isEmpty else { return }
        
        speechService.speak(text)
        
        let phrase = Phrase(
            text: text,
            createdAt: .now,
            lastUsedAt: .now,
            useCount: 1,
            isFavorite: false
        )
        
        modelContext.insert(phrase) // insert newly created Phrase entity
        
        do {
            try modelContext.save()
            print("saved phrase:", text)
        } catch {
            print("failed to save phrase bc of:", error.localizedDescription)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Phrase.self, inMemory: true) // this helps with xcode bs and offline support as chatgpt says “Use a temporary SwiftData container that disappears when the preview reloads.” lol this goober lol love you chat
}
