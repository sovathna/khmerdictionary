//
// Created by Sovathna Hong on 12/9/22.
//

import SwiftUI

struct SearchView: View {
    @State private var searchQuery: String = ""
    @ObservedObject private var viewModel: WordsViewModel
    private var isSearching: FocusState<Bool>.Binding

    init(
        @ObservedObject
        _ viewModel: WordsViewModel,
        _ isSearching: FocusState<Bool>.Binding
    ) {
        self.viewModel = viewModel
        self.isSearching = isSearching
    }

    var body: some View {
        HStack {
            TextField("ស្វែងរកពាក្យ", text: $searchQuery)
                    .focused(isSearching)
                    .font(textFont)
                    .textFieldStyle(.plain)
                    .submitLabel(.search)

            if searchQuery.count > 0 {
                Button(
                    action: {
                        searchQuery = ""
                    },
                    label: {
                        Label("បិទ", systemImage: "xmark.circle.fill")
                                .labelStyle(.iconOnly)
                    }
                )
            }
        }.padding(.vertical, 8)
         .padding(.horizontal, 16)
         .background(contentBgColor, in: RoundedRectangle(cornerRadius: 8))
         .padding(.horizontal)
         .onChange(of: searchQuery) { query in
             viewModel.search(query)
         }
    }
}