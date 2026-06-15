//
//  ContentView.swift
//  speakForMe
//
//  Created by Jameka Echols on 6/13/26.
//

import SwiftUI

struct ContentView: View {
   @State private var speechService = SpeechService()
    
    var body: some View {
        VStack {
            Button("Speak Test") {
                speechService.speak("I need water")
            }
        }
        .buttonStyle(.borderedProminent)
        .padding()
    }
}

#Preview {
    ContentView()
}
