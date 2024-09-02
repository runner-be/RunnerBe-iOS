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
        return WriteLogViewModel(postId: postId)
    }

    var postId: Int

    init(postId: Int) {
        self.postId = postId
    }

    func logStampBottomSheetComponent(selectedLogStamp: LogStamp2) -> LogStampBottomSheetComponent {
        return LogStampBottomSheetComponent(selectedLogStamp: selectedLogStamp)
    }

    var takePhotoModalComponent: TakePhotoModalComponent {
        return TakePhotoModalComponent()
    }
}
