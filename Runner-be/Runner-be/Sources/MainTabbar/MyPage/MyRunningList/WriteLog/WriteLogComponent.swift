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
        return WriteLogViewModel(
            logForm: logForm,
            writeLogMode: writeLogMode
        )
    }

    var logForm: LogForm
    var writeLogMode: WriteLogMode

    init(
        logForm: LogForm,
        writeLogMode: WriteLogMode
    ) {
        self.logForm = logForm
        self.writeLogMode = writeLogMode
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

    func stampBottomSheetComponent(
        selectedStamp: StampType,
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

    func togetherRunnerComponent(
        logId: Int,
        gatheringId: Int
    ) -> TogetherRunnerComponent {
        return TogetherRunnerComponent(
            logId: logId,
            gatheringId: gatheringId
        )
    }

    var logModalComponent: LogModalComponent {
        return LogModalComponent()
    }
}
