//
//  WordRow.swift
//  khmerdictionary
//
//  Created by Sovathna Hong on 8/9/22.
//

import SwiftUI

struct WordRow: View {

    private var word: WordUi

    init(_ word: WordUi) {
        self.word = word
    }

    var body: some View {
        HStack {
            Text(word.word).font(textFont)
            Spacer()
        }.padding(.vertical, 8)
         .padding(.horizontal, 16)
         .listRowSeparator(.hidden)
         .background(contentBgColor, in: RoundedRectangle(cornerRadius: 8))
    }
}

