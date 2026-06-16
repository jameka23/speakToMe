//
//  HistoryView.swift
//  speakForMe
//
//  Created by Jameka Echols on 6/15/26.
//


import SwiftUI
import SwiftData

struct HistoryView: View {
    
    //fetch saved phrases from SwiftData with the newest first
    @Query(sort: \Phrase.lastUsedAt, order: .reverse) private var phrases: [Phrase]
    
    var body: some View {
        NavigationStack {
            List {
                if phrases.isEmpty {
                    Text("No spoken phrases yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(phrases) { phrase in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(phrase.text)
                                .font(.headline)
                            
                            Text("Used \(phrase.useCount) time\(phrase.useCount == 1 ? "" : "s")")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("History")
        }
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: Phrase.self, inMemory: true)
}
