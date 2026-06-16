//
//  MainTabView.swift
//  speakForMe
//
//  Created by Jameka Echols on 6/15/26.
//

import SwiftUI
import SwiftData

enum AppTab: Hashable {
    case home
    case history
    case settings
}

struct MainTabView: View {
    @State private var selectedTab: AppTab = .home

    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab( "Home", systemImage: "house", value: .home) {
                ContentView()
            }

            Tab("History", systemImage: "clock", value: .history){
                HistoryView()
            }
            
            Tab("Settings", systemImage: "gearshape", value: .settings) {
                SettingsView()
            }
        }
        .applyTabBarMinimizeBehavior()
    }
}

private extension View {
    @ViewBuilder
    func applyTabBarMinimizeBehavior() -> some View {
        if #available(iOS 26.0, *) {
            self.tabBarMinimizeBehavior(.onScrollDown)
        } else {
            self
        }
    }
}

#Preview {
    MainTabView()
}
