import SwiftUI
import SwiftData

enum HistorySortOption: String, CaseIterable, Identifiable {
    case recent = "Recent"
    case mostUsed = "Most Used"

    var id: String { rawValue }
}

struct HistoryView: View {

    @Environment(\.modelContext) private var modelContext

    @Query private var phrases: [Phrase]

    @State private var speechService = SpeechService()
    @State private var sortOption: HistorySortOption = .recent

    let onReusePhrase: (String) -> Void

    private var sortedPhrases: [Phrase] {
        phrases.sorted { first, second in
            if first.isFavorite != second.isFavorite {
                return first.isFavorite && !second.isFavorite
            }

            switch sortOption {
            case .recent:
                return first.lastUsedAt > second.lastUsedAt

            case .mostUsed:
                if first.useCount != second.useCount {
                    return first.useCount > second.useCount
                }

                return first.lastUsedAt > second.lastUsedAt
            }
        }
    }

    var body: some View {
        NavigationStack {
            List {
                if sortedPhrases.isEmpty {
                    Text("No spoken phrases yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(sortedPhrases) { phrase in
                        HStack(spacing: 12) {
                            Button {
                                reusePhrase(phrase)
                            } label: {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(phrase.text)
                                        .font(.headline)
                                        .foregroundStyle(.primary)

                                    Text("Used \(phrase.useCount) time\(phrase.useCount == 1 ? "" : "s")")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("Reuse phrase \(phrase.text)")
                            .accessibilityHint("Loads this phrase on the Home screen")

                            Spacer()

                            Button {
                                toggleFavorite(phrase)
                            } label: {
                                Image(systemName: phrase.isFavorite ? "star.fill" : "star")
                            }
                            .buttonStyle(.borderless)
                            .accessibilityLabel(phrase.isFavorite ? "Remove from favorites" : "Add to favorites")

                            Button {
                                speakPhraseAgain(phrase)
                            } label: {
                                Image(systemName: "speaker.wave.2.fill")
                            }
                            .buttonStyle(.borderless)
                            .accessibilityLabel("Speak phrase again")
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete(perform: deletePhrases)
                }
            }
            .navigationTitle("History")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Picker("Sort", selection: $sortOption) {
                        ForEach(HistorySortOption.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
        }
    }

    private func reusePhrase(_ phrase: Phrase) {
        updateUsage(for: phrase)
        onReusePhrase(phrase.text)
    }

    private func speakPhraseAgain(_ phrase: Phrase) {
        speechService.speak(phrase.text)
        updateUsage(for: phrase)
    }

    private func toggleFavorite(_ phrase: Phrase) {
        phrase.isFavorite.toggle()
        saveChanges()
    }

    private func updateUsage(for phrase: Phrase) {
        phrase.useCount += 1
        phrase.lastUsedAt = .now
        saveChanges()
    }

    private func deletePhrases(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(sortedPhrases[index])
        }

        saveChanges()
    }

    private func saveChanges() {
        do {
            try modelContext.save()
        } catch {
            print("failed to save history changes:", error.localizedDescription)
        }
    }
}

#Preview {
    HistoryView { _ in }
        .modelContainer(for: Phrase.self, inMemory: true)
}
