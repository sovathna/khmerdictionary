//
// Created by Sovathna Hong on 12/9/22.
//

import Foundation

class BaseViewModel<S>: ObservableObject {

    @Published final var state: S

    init(_ initState: S) {
        state = initState
    }

    final func runOnBackground(_ code: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async(execute: code)
    }

    final func setState(_ state: S) {
        DispatchQueue.main.async {
            self.state = state
        }
    }
}