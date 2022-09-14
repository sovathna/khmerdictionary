//
// Created by Sovathna Hong on 9/9/22.
//

import Foundation

struct DefinitionState: Hashable {
    var definition: DefinitionUi? = nil
    var isBookmark: Bool = false
    var fontSize: Float = 16

    func copyWith(
        definition: DefinitionUi? = nil,
        isBookmark: Bool? = nil,
        fontSize: Float? = nil
    ) -> DefinitionState {
        DefinitionState(
            definition: definition ?? self.definition,
            isBookmark: isBookmark ?? self.isBookmark,
            fontSize: fontSize ?? self.fontSize
        )
    }
}
