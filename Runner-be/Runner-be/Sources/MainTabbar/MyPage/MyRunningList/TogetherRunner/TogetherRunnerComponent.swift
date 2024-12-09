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
        return TogetherRunnerViewModel(
            logId: logId,
            gatheringId: gatheringId
        )
    }

    let logId: Int?
    let gatheringId: Int

    init(
        logId: Int?,
        gatheringId: Int
    ) {
        self.logId = logId
        self.gatheringId = gatheringId
    }

    func logStampBottomSheetComponent(
        selectedLogStamp: StampType,
        title: String,
        gatheringId: Int?
    ) -> LogStampBottomSheetComponent {
        return LogStampBottomSheetComponent(
            selectedLogStamp: selectedLogStamp,
            title: title,
            gatheringId: gatheringId
        )
    }

    func confirmLogComponent(logId: Int) -> ConfirmLogComponent {
        return ConfirmLogComponent(logId: logId)
    }

    func userPageComponent(userId: Int) -> UserPageComponent {
        return UserPageComponent(userId: userId)
    }
}
