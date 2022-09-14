//
// Created by Sovathna Hong on 12/9/22.
//

import SwiftUI

struct TitleView: View {

    private var type: WordsType

    init(_ type: WordsType) {
        self.type = type
    }

    private var title: String {
        switch (type) {
        case .words:
            return "វចនានុក្រមខ្មែរ"
        case .histories:
            return "បញ្ជីពាក្យធ្លាប់មើល"
        case .bookmarks:
            return "បញ្ជីពាក្យចំណាំ"
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Text(title)
                    .font(titleFont)
                    .padding(.vertical, 8)
            Divider()
        }.background(contentBgColor)
    }
}