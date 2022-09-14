//
//  WordsState.swift
//  khmerdictionary
//
//  Created by Sovathna Hong on 8/9/22.
//

import Foundation

struct WordsState: Hashable {

    var isInit: Bool = true
    var isLoading: Bool = false
    var page: Int = 1
    var words: [WordUi]? = nil
    var isMore: Bool = false
    var searchQuery: String = ""

    func copyWith(
        isInit: Bool? = nil,
        isLoading: Bool? = nil,
        page: Int? = nil,
        words: [WordUi]? = nil,
        isMore: Bool? = nil,
        searchQuery: String? = nil
    ) -> WordsState {
        WordsState(
            isInit: isInit ?? self.isInit,
            isLoading: isLoading ?? self.isLoading,
            page: page ?? self.page,
            words: words ?? self.words,
            isMore: isMore ?? self.isMore,
            searchQuery: searchQuery ?? self.searchQuery
        )
    }

}

struct WordUi: Hashable, Identifiable {
    var id: Int64
    var word: String
}

enum WordsType {
    case words
    case histories
    case bookmarks
}