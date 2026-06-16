//
//  SettingsView.swift
//  speakForMe
//
//  Created by Jameka Echols on 6/15/26.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Settings")
                    .font(.title)
                
                Text("Voice, accessibility, etc.")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
