//
//  DefinitionView.swift
//  khmerdictionary
//
//  Created by Sovathna Hong on 8/9/22.
//

import SwiftUI

struct DefinitionView: View {
    @StateObject var viewModel: DefinitionViewModel
    @Binding var wordId: Int64

    @State private var definitionString = AttributedString()

    var body: some View {
        VStack {
            if let def = viewModel.state.definition {
                HStack {
                    Text(def.word)
                            .font(titleFont)
                            .padding(.horizontal)
                    Spacer()

                    Button(
                        action: viewModel.decreaseFontSize,
                        label: {
                            Label("decrease", systemImage: "minus.magnifyingglass")
                                    .labelStyle(.iconOnly)
                        }
                    ).padding(.trailing)

                    Button(
                        action: viewModel.increaseFontSize,
                        label: {
                            Label("increase", systemImage: "plus.magnifyingglass")
                                    .labelStyle(.iconOnly)
                        }
                    ).padding(.trailing)

                    Button(
                        action: viewModel.addOrDeleteBookmark,
                        label: {
                            Label("bookmark", systemImage: viewModel.state.isBookmark ? "bookmark.fill" : "bookmark")
                                    .labelStyle(.iconOnly)
                        }
                    ).padding(.horizontal)
                }.padding(.vertical, 8)
                 .background(contentBgColor, in: RoundedRectangle(cornerRadius: 8))
                 .padding(.trailing)

                ScrollView(.vertical, showsIndicators: true) {
                    Text(definitionString)
                            .multilineTextAlignment(.leading)
                            .font(Font.custom(fontName, size: CGFloat(viewModel.state.fontSize)))
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .background(contentBgColor, in: RoundedRectangle(cornerRadius: 8))
                            .padding(.trailing)
                            .padding(.bottom)
                            .padding(.top, 8)
                }

            } else {
                Text("សូមចុចលើពាក្យដើម្បីមើលពន្យល់ន័យ")
                        .font(titleFont)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .padding()
            }
        }.onAppear {
             getDefinition(wordId)
         }
         .onOpenURL { url in
             guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
                   let params = components.queryItems,
                   let wordId = params.first(where: { param in param.name == "word_id" })?.value
             else {
                 print("Invalid URL or album path missing")
                 return
             }
             getDefinition(Int64(wordId) ?? 1)
         }.onChange(of: wordId) { newValue in
             getDefinition(newValue)
         }.onChange(of: viewModel.state.definition?.definition) { values in
             DispatchQueue.main.async {
                 definitionString = AttributedString()
                 values?.forEach { word in
                     if word.id != nil {
                         var t = AttributedString(word.value)
                         t.foregroundColor = .label
                         t.link = URL(string: "sovathnaapp:khmerdictionary?word_id=\(word.id!)")
                         definitionString.append(t)
                     } else {
                         var t = AttributedString(word.value)
                         t.foregroundColor = .label
                         definitionString.append(t)
                     }
                 }
             }
         }
    }

    private func getDefinition(_ id: Int64) {
        viewModel.getDefinition(id)
    }
}
