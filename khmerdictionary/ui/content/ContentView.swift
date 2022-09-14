//
//  ContentView.swift
//  khmerdictionary
//
//  Created by Sovathna Hong on 3/9/22.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject private var repo: AppRepository
    @State private var shouldShowContent: Bool = false

    @Binding var isDarkScheme: Bool

    var body: some View {
        if shouldShowContent {
            TabView {
                WordsScreen(viewModel: WordsViewModel(repo, .words))
                        .environmentObject(repo)
                        .tabItem {
                            Label("បញ្ជីពាក្យ", systemImage: "house")
                        }
                WordsScreen(viewModel: WordsViewModel(repo, .histories))
                        .environmentObject(repo)
                        .tabItem {
                            Label("បញ្ជីពាក្យធ្លាប់មើល", systemImage: "clock")
                        }
                WordsScreen(viewModel: WordsViewModel(repo, .bookmarks))
                        .environmentObject(repo)
                        .tabItem {
                            Label("បញ្ជីពាក្យចំណាំ", systemImage: "book")
                        }
                SettingsView(isDarkScheme: $isDarkScheme)
                        .environmentObject(repo)
                        .tabItem {
                            Label("ការកំណត់", systemImage: "gear")
                        }
            }
        } else {
            SplashView(viewModel: SplashViewModel(repo), shouldShowMain: $shouldShowContent)
                    .environmentObject(repo)
        }
    }
}
