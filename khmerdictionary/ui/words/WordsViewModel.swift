//
//  WordsViewModel.swift
//  khmerdictionary
//
//  Created by Sovathna Hong on 8/9/22.
//

import Foundation
import SQLite

final class WordsViewModel: BaseViewModel<WordsState> {

    private var repo: AppRepository

    var type: WordsType

    init(_ repo: AppRepository, _ type: WordsType) {
        self.repo = repo
        self.type = type
        super.init(WordsState())
    }

    func getMoreWords() {
        if !state.isMore {
            return
        }
        getWords(state.page + 1, state.searchQuery)
    }

    func getWords(_ page: Int, _ query: String) {
        if state.isLoading {
            return
        }
        runOnBackground {
            var newState = self.state.copyWith(
                isInit: false,
                isLoading: true,
                page: page,
                isMore: false,
                searchQuery: query
            )
            self.setState(newState)

            var tmp: [WordUi] = self.state.words ?? []

            if page == 1 {
                tmp.removeAll()
            }

            let words = self.type == .words ?
                self.repo.getWords(page, query) :
                (
                    self.type == .histories ?
                        self.repo.getLocalWords(true, page, query) :
                        self.repo.getLocalWords(false, page, query)
                )

            tmp.append(contentsOf: words)
            newState = self.state.copyWith(
                isLoading: false,
                words: tmp,
                isMore: words.count >= Const.PAGE_SIZE

            )
            self.setState(newState)

        }

    }

    private var searchTimer: Timer? = nil

    private var searchWork: DispatchWorkItem? = nil

    func search(_ query: String) {
        searchWork?.cancel()
        searchWork = DispatchWorkItem {
            if query != self.state.searchQuery {
                self.getWords(1, query)
            }
        }
        DispatchQueue
                .global(qos: .userInitiated)
                .asyncAfter(
                    deadline: .now().advanced(by: .milliseconds(600)),
                    execute: searchWork!
                )
    }

}
