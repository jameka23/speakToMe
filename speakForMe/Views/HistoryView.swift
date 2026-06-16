import SwiftUI
import SwiftData

struct HistoryView: View {

    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Phrase.lastUsedAt, order: .reverse) private var phrases: [Phrase]

    @State private var speechService = SpeechService()

    let onReusePhrase: (String) -> Void

    var body: some View {
        NavigationStack {
            List {
                if phrases.isEmpty {
                    Text("No spoken phrases yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(phrases) { phrase in
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

                            Spacer()

                            Button {
                                toggleFavorite(phrase)
                            } label: {
                                Image(systemName: phrase.isFavorite ? "star.fill" : "star")
                            }
                            .buttonStyle(.borderless)

                            Button {
                                speakPhraseAgain(phrase)
                            } label: {
                                Image(systemName: "speaker.wave.2.fill")
                            }
                            .buttonStyle(.borderless)
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete(perform: deletePhrases)
                }
            }
            .navigationTitle("History")
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
            modelContext.delete(phrases[index])
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
