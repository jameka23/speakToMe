//
//  speakForMeApp.swift
//  speakForMe
//
//  Created by Jameka Echols on 6/13/26.
//

import SwiftUI
import SwiftData

@main
struct speakForMeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Phrase.self) // setting swiftdata and making sure Phrase is stored 
    }
}
