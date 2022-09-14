//
//  WordsView.swift
//  khmerdictionary
//
//  Created by Sovathna Hong on 8/9/22.
//

import SwiftUI

struct WordsView: View {
    @ObservedObject private var viewModel: WordsViewModel
    private var isSearching: FocusState<Bool>.Binding
    private var onItemClick: (Int64) -> Void

    init(
        @ObservedObject
        _ viewModel: WordsViewModel,
        _ isSearching: FocusState<Bool>.Binding,
        _ onItemClick: @escaping (Int64) -> Void
    ) {
        self.viewModel = viewModel
        self.isSearching = isSearching
        self.onItemClick = onItemClick
    }

    var body: some View {
        if let words = viewModel.state.words {
            if words.count > 0 {
                ScrollViewReader { proxy in
                    List(words) { word in
                        WordRow(word)
                                .onAppear {
                                    if isSearching.wrappedValue {
                                        isSearching.wrappedValue = false
                                    }
                                    if words.last?.id == word.id {
                                        viewModel.getMoreWords()
                                    }
                                }
                                .onTapGesture {
                                    onItemClick(word.id)
                                }

                    }.listStyle(.plain)
                     .onChange(of: viewModel.state.searchQuery) { _ in
                         withAnimation {
                             proxy.scrollTo(viewModel.state.words?.first?.id ?? 0, anchor: .top)
                         }
                     }
                }
            } else {
                Spacer()
                Text("មិនមានពាក្យ").font(titleFont)
                Spacer()
            }
        } else {
            Spacer()
        }
    }
}