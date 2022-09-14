//
//  khmerdictionaryApp.swift
//  khmerdictionary
//
//  Created by Sovathna Hong on 3/9/22.
//

import SwiftUI

@main
struct KhmerDictionaryApp: App {
    @StateObject private var repo = AppRepository()
    @State private var isDarkScheme: Bool = true

    var body: some Scene {
        WindowGroup {
            ContentView(isDarkScheme: $isDarkScheme)
                    .environmentObject(repo)
                    .preferredColorScheme(isDarkScheme ? .dark : .light)
                    .onAppear {
                        DispatchQueue.main.async {
                            let isDark = repo.isDarkScheme()
                            isDarkScheme = isDark
                        }
                    }
                    .onChange(of: isDarkScheme) { isDark in
                        DispatchQueue.main.async {
                            repo.setColorScheme(isDark)
                        }
                    }
        }
    }
}

let fontName = "Hanuman"
let titleFont = Font.custom("Hanuman", size: 18)
let textFont = Font.custom("Hanuman", size: 16)
let subFont = Font.custom("Hanuman", size: 14)

let contentBgColor = Color(UIColor.secondarySystemBackground)
let bgColor = Color(UIColor.systemBackground)