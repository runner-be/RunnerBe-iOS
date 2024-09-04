//
//  LogStampBottomSheetComponent.swift
//  Runner-be
//
//  Created by 김창규 on 9/1/24.
//

import UIKit

final class LogStampBottomSheetComponent {
    var scene: (VC: UIViewController, VM: LogStampBottomSheetViewModel) {
        let viewModel = self.viewModel
        let title = self.title
        return (LogStampBottomSheetViewController(
            viewModel: viewModel,
            title: title
        ), viewModel)
    }

    var viewModel: LogStampBottomSheetViewModel {
        return LogStampBottomSheetViewModel(selectedStamp: selectedStamp)
    }

    var selectedStamp: LogStamp2
    var title: String

    init(
        selectedLogStamp: LogStamp2,
        title: String
    ) {
        selectedStamp = selectedLogStamp
        self.title = title
    }
}
