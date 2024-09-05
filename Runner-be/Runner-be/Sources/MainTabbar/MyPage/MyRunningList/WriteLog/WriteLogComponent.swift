//
//  WriteLogComponent.swift
//  Runner-be
//
//  Created by 김창규 on 8/30/24.
//

import Foundation

final class WriteLogComponent {
    var scene: (VC: WriteLogViewController, VM: WriteLogViewModel) {
        let viewModel = self.viewModel
        return (VC: WriteLogViewController(viewModel: viewModel), VM: viewModel)
    }

    var viewModel: WriteLogViewModel {
        return WriteLogViewModel(logForm: logForm)
    }

    var logForm: LogForm

    init(logForm: LogForm) {
        self.logForm = logForm
    }

    func logStampBottomSheetComponent(
        selectedLogStamp: LogStamp2,
        title: String
    ) -> LogStampBottomSheetComponent {
        return LogStampBottomSheetComponent(
            selectedLogStamp: selectedLogStamp,
            title: title
        )
    }

    func stampBottomSheetComponent(
        selectedStamp: LogStamp2,
        selectedTemp: String
    ) -> StampBottomSheetComponent {
        return StampBottomSheetComponent(
            selectedStamp: selectedStamp,
            selectedTemp: selectedTemp
        )
    }

    var takePhotoModalComponent: TakePhotoModalComponent {
        return TakePhotoModalComponent(isShowBasicImageOption: false)
    }

    var togetherRunnerComponent: TogetherRunnerComponent {
        return TogetherRunnerComponent()
    }
}
