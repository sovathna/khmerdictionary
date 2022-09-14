//
// Created by Sovathna Hong on 12/9/22.
//

import SwiftUI

struct WordsScreen: View {
    @EnvironmentObject private var repo: AppRepository
    @StateObject var viewModel: WordsViewModel

    @FocusState private var isSearching: Bool

    @State private var wordId: Int64 = 0

    @State private var presentingDefinition: Bool = false

    var body: some View {
        VStack {
            TitleView(viewModel.type)

            GeometryReader { geometry in
                let shouldPresentDefinition = geometry.size.width < 480
                HStack {
                    VStack {
                        SearchView(viewModel, $isSearching)

                        WordsView(viewModel, $isSearching) { wordId in
                            self.wordId = wordId
                            hideKeyboard()
                            if shouldPresentDefinition {
                                presentingDefinition.toggle()
                            }
                        }

                    }.frame(
                        maxWidth: shouldPresentDefinition ? .infinity : geometry.size.width * 1 / 3
                    )

                    if !shouldPresentDefinition {
                        DefinitionView(viewModel: DefinitionViewModel(repo), wordId: $wordId)
                    }
                }
            }
        }.onAppear {
            getInit()
        }.sheet(isPresented: $presentingDefinition) {
            GeometryReader { geometry in
                DefinitionView(viewModel: DefinitionViewModel(repo), wordId: $wordId)
                        .padding(.leading)
                        .padding(.top)
                        .onChange(of: geometry.size.width) { width in
                            if width >= 480 {
                                presentingDefinition.toggle()
                            }
                        }
            }
        }

    }

    private func hideKeyboard() {
        if isSearching {
            isSearching.toggle()
        }
    }

    private func getInit() {
        if viewModel.state.isInit || viewModel.type != .words {
            viewModel.getWords(1, "")
        }
    }
}