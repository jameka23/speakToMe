//
//  ContentView.swift
//  speakForMe
//
//  Created by Jameka Echols on 6/13/26.
//

import SwiftUI

struct ContentView: View {
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
                    speechService.speak(draft.text)
                }
                .buttonStyle(.borderedProminent)
                .disabled(draft.text.isEmpty)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
