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
    
    @Query(sort: \Phrase.lastUsedAt, order: .reverse) private var savedPhrases: [Phrase]
    
    @Binding var phraseToReuse: String?
    
    @State private var speechService = SpeechService()
    @State private var draft = SentenceDraft()
    

    
    private let predictionService = PredictionService()
    
    private var predictionResult: PredictionResult {
        predictionService.predict(for: draft, savedPhrases: savedPhrases)
    }
    
    var body: some View {
        GeometryReader { geometry in
            let isCompactHeight = geometry.size.height < 700
            let horizontalPadding: CGFloat = 16
            let verticalSpacing: CGFloat = isCompactHeight ? 14 : 24
            let sentenceMinHeight: CGFloat = isCompactHeight ? 80 : 110
            let wordButtonMinHeight: CGFloat = isCompactHeight ? 58 : 72
            let actionButtonMinHeight: CGFloat = isCompactHeight ? 50 : 56
            let gridSpacing: CGFloat = isCompactHeight ? 12 : 16

            ScrollView {
                VStack(spacing: verticalSpacing) {
                    Text(draft.text.isEmpty ? "Build your sentence..." : draft.text)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.75)
                        .lineLimit(3)
                        .frame(maxWidth: .infinity, minHeight: sentenceMinHeight)
                        .padding()
                        .background(.gray.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .accessibilityLabel("Current sentence")
                        .accessibilityValue(draft.text.isEmpty ? "No words added yet" : draft.text)

                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: gridSpacing),
                            GridItem(.flexible(), spacing: gridSpacing)
                        ],
                        spacing: gridSpacing
                    ) {
                        ForEach(predictionResult.suggestions) { word in
                            Button {
                                draft.words.append(word.text)
                            } label: {
                                Text(word.text)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .minimumScaleFactor(0.75)
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity, minHeight: wordButtonMinHeight)
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                            .accessibilityLabel("Add \(word.text)")
                            .accessibilityHint("Adds \(word.text) to the current sentence")
                        }
                    }

                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            Button {
                                guard !draft.words.isEmpty else { return }
                                draft.words.removeLast()
                            } label: {
                                Label("Delete", systemImage: "delete.left")
                                    .font(.headline)
                                    .minimumScaleFactor(0.75)
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity, minHeight: actionButtonMinHeight)
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.large)
                            .disabled(draft.words.isEmpty)
                            .accessibilityLabel("Delete last word")

                            Button {
                                draft.words.removeAll()
                            } label: {
                                Label("Clear", systemImage: "xmark.circle")
                                    .font(.headline)
                                    .minimumScaleFactor(0.75)
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity, minHeight: actionButtonMinHeight)
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.large)
                            .disabled(draft.words.isEmpty)
                            .accessibilityLabel("Clear sentence")
                        }

                        Button {
                            speakAndSave()
                        } label: {
                            Label("Speak Sentence", systemImage: "speaker.wave.2.fill")
                                .font(.headline)
                                .minimumScaleFactor(0.75)
                                .lineLimit(1)
                                .frame(maxWidth: .infinity, minHeight: actionButtonMinHeight)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .disabled(draft.text.isEmpty)
                        .accessibilityLabel("Speak sentence")
                        .accessibilityHint("Speaks the current sentence out loud")
                    }
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.top, isCompactHeight ? 12 : 20)
                .padding(.bottom, 24)
                .frame(maxWidth: 700)
                .frame(maxWidth: .infinity)
            }
            .scrollIndicators(.hidden)
        }
        .dynamicTypeSize(...DynamicTypeSize.accessibility3)
        .onChange(of: phraseToReuse) { _, newValue in
            guard let newValue else { return }

            draft.words = newValue
                .split(separator: " ")
                .map(String.init)

            phraseToReuse = nil
        }
    }
    
    /// This method saves the sentence that is spoken into history once a user hits the 'Speak' button
    private func speakAndSave() {
        let text = draft.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !text.isEmpty else { return }
        
        speechService.speak(text)
        
        
        // double check if phrase is already in history and if it is, update count else insert as new 
        if let existingPhrase = savedPhrases.first(where: {
                $0.text.lowercased() == text.lowercased()
            }) {
                existingPhrase.useCount += 1
                existingPhrase.lastUsedAt = .now
            } else {
                let phrase = Phrase(
                    text: text,
                    createdAt: .now,
                    lastUsedAt: .now,
                    useCount: 1,
                    isFavorite: false
                )

                modelContext.insert(phrase)// insert newly created Phrase entity
            }
        
        do {
            try modelContext.save()
            print("saved phrase:", text)
        } catch {
            print("failed to save phrase bc of:", error.localizedDescription)
        }
    }
}

#Preview {
    ContentView(phraseToReuse: .constant(nil))
        .modelContainer(for: Phrase.self, inMemory: true) // this helps with xcode bs and offline support as chatgpt says “Use a temporary SwiftData container that disappears when the preview reloads.” lol this goober lol love you chat
}
