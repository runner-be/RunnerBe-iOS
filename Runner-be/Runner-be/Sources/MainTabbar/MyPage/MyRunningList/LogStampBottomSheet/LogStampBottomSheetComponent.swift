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
        return (LogStampBottomSheetViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: LogStampBottomSheetViewModel {
        return LogStampBottomSheetViewModel(selectedStamp: selectedStamp)
    }

    var selectedStamp: LogStamp2

    init(selectedLogStamp: LogStamp2) {
        selectedStamp = selectedLogStamp
    }
}
