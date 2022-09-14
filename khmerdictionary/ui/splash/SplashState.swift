//
// Created by Sovathna Hong on 5/9/22.
//

import Foundation

struct SplashState: Hashable {
    var isInit: Bool = true
    var progress: Double = 0.0
    var isDone: Bool = false

    var isLoading: Bool {
        progress == 0.0 || progress == 1.0
    }

    var title: String {
        if progress == 0.0 {
            return "កំពុងរៀបចំទាញយកទិន្នន័យ សូមមេត្តារង់ចាំ...!"
        } else if progress == 1.0 {
            return "កំពុងរៀបចំការកំណត់ សូមមេត្តារង់ចាំ...!"
        }
        return "កំពុងទាញយកទិន្នន័យ...!"
    }

    var subTitle: String? {
        let shouldShow = progress > 0.0 && progress < 1.0
        if shouldShow {
            return "\(Int(progress * 100))%"
        }
        return nil
    }

    func copyWith(
        isInit: Bool? = nil,
        progress: Double? = nil,
        isDone: Bool? = nil
    ) -> SplashState {
        SplashState(
            isInit: isInit ?? self.isInit,
            progress: progress ?? self.progress,
            isDone: isDone ?? self.isDone
        )
    }
}
