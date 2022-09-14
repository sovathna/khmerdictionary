//
// Created by Sovathna Hong on 9/9/22.
//

import Foundation

final class DefinitionViewModel: BaseViewModel<DefinitionState> {

    private var repo: AppRepository

    init(_ repo: AppRepository) {
        self.repo = repo
        super.init(DefinitionState())
    }

    func getDefinition(_ id: Int64) {
        if state.definition?.id == id {
            return
        }
        runOnBackground {
            if let def = self.repo.getDefinition(id) {
                let isBookmark = self.repo.getLocalWord(false, def.id) != nil
                let fontSize = self.repo.getFontSize()
                self.repo.addLocalWord(true, def.id, def.word)
                self.setState(self.state.copyWith(definition: def, isBookmark: isBookmark, fontSize: fontSize))
            }
        }
    }

    func addOrDeleteBookmark() {
        runOnBackground {
            if let def = self.state.definition {
                if self.state.isBookmark {
                    self.repo.deleteBookmark(def.id)
                } else {
                    self.repo.addLocalWord(false, def.id, def.word)
                }
                let isBookmark = self.repo.getLocalWord(false, def.id) != nil
                self.setState(self.state.copyWith(isBookmark: isBookmark))
            }
        }
    }

    func increaseFontSize() {
        runOnBackground {
            var fontSize = self.repo.getFontSize() + 2
            if fontSize > 50 {
                fontSize = 50
            }
            self.repo.setFontSize(fontSize)
            self.setState(self.state.copyWith(fontSize: fontSize))
        }
    }

    func decreaseFontSize() {
        runOnBackground {
            var fontSize = self.repo.getFontSize() - 2
            if fontSize < 16 {
                fontSize = 16
            }
            self.repo.setFontSize(fontSize)
            self.setState(self.state.copyWith(fontSize: fontSize))
        }
    }
}
