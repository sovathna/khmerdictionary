//
// Created by Sovathna Hong on 11/9/22.
//

import SwiftUI

struct SettingsView: View {
    @Binding var isDarkScheme: Bool
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                Text("ការកំណត់")
                        .font(titleFont)
                        .padding(.vertical, 8)
                Divider()
            }.frame(maxWidth: .infinity)
             .background(contentBgColor)
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading) {
                    Text("ពណ៌ផ្ទៃ")
                            .padding(.horizontal, 32)
                            .font(subFont)
                            .foregroundColor(Color(UIColor.secondaryLabel))

                    Toggle("ពណ៌ផ្ទៃងងឹត", isOn: $isDarkScheme)
                            .font(textFont)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(contentBgColor, in: RoundedRectangle(cornerRadius: 8))
                            .padding(.horizontal)
                            .padding(.top, -16)


                    Text("អំពីកម្មវិធី")
                            .padding(.top, 16)
                            .padding(.horizontal, 32)
                            .font(subFont)
                            .foregroundColor(Color(UIColor.secondaryLabel))

                    Text("អភិវឌ្ឍដោយ៖ ហុង សុវឌ្ឍនា\nពុម្ពអក្សរប្រើប្រាស់៖ Hanuman\n[កូដរបស់កម្មវិធីនេះមាននៅលើGitHub](https://github.com/sovathna/khmerdictionary)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineSpacing(8)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .font(textFont)
                            .background(contentBgColor, in: RoundedRectangle(cornerRadius: 8))
                            .padding(.horizontal)
                            .padding(.top, -16)


                }.padding(.vertical)
                 .toggleStyle(.switch)
            }
        }
    }
}
