//
//  TogetherRunnerComponent.swift
//  Runner-be
//
//  Created by 김창규 on 9/3/24.
//

import UIKit

final class TogetherRunnerComponent {
    var scene: (VC: UIViewController, VM: TogetherRunnerViewModel) {
        let viewModel = self.viewModel
        return (TogetherRunnerViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: TogetherRunnerViewModel {
        return TogetherRunnerViewModel(gatheringId: gatheringId)
    }

    let gatheringId: Int

    init(gatheringId: Int) {
        self.gatheringId = gatheringId
    }

    func logStampBottomSheetComponent(selectedLogStamp: StampType, title: String) -> LogStampBottomSheetComponent {
        return LogStampBottomSheetComponent(
            selectedLogStamp: selectedLogStamp,
            title: title
        )
    }

    func confirmLogComponent(logId: Int) -> ConfirmLogComponent {
        return ConfirmLogComponent(logId: logId)
    }
}
