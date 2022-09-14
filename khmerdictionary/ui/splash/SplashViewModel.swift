//
// Created by Sovathna Hong on 5/9/22.
//

import Foundation
import Alamofire
import ZIPFoundation

final class SplashViewModel: BaseViewModel<SplashState> {

    private var repo: AppRepository

    private var downloadRequest: Request?

    init(_ repo: AppRepository) {
        self.repo = repo
        super.init(SplashState())
    }

    func downloadFile() {
        runOnBackground {
            self.setState(self.state.copyWith(isInit: false, isDone: false))
            self.downloadRequest = self.repo.downloadFile(
                onProgress: {
                    self.setState(self.state.copyWith(progress: $0))
                },
                onDone: {
                    self.setState(self.state.copyWith(isInit: false, progress: 1.0, isDone: true))
                }
            )
        }
    }

    deinit {
        downloadRequest?.cancel()
    }

}
