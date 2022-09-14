//
// Created by Sovathna Hong on 9/9/22.
//

import Foundation

struct DefinitionUi: Hashable, Identifiable {
    var id: Int64
    var word: String
    var definition: [DefWord]
}

struct DefWord: Hashable {
    var id: Int64? = nil
    var value: String
}
