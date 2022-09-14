//
// Created by Sovathna Hong on 5/9/22.
//

import SwiftUI

struct SplashView: View {

    @StateObject var viewModel: SplashViewModel
    @Binding var shouldShowMain: Bool

    var body: some View {
        VStack {
            Text(viewModel.state.title)
                    .font(titleFont)
                    .multilineTextAlignment(.center)
            if viewModel.state.isLoading {
                ProgressView()
            } else {
                ProgressView(value: viewModel.state.progress, total: 1.0)
                        .progressViewStyle(.linear)
                if let subTitle = viewModel.state.subTitle {
                    HStack {
                        Spacer()
                        Text(subTitle)
                                .font(Font.caption)
                    }
                }

            }

        }.padding(.horizontal, 32)
         .onAppear {
             if viewModel.state.isInit {
                 viewModel.downloadFile()
             }
         }
         .onChange(of: viewModel.state.isDone) { newValue in
             shouldShowMain = newValue
         }
    }
}
