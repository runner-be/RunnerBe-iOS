//
//  StampBottomSheetComponent.swift
//  Runner-be
//
//  Created by 김창규 on 9/2/24.
//

import UIKit

final class StampBottomSheetComponent {
    var scene: (VC: UIViewController, VM: StampBottomSheetViewModel) {
        let viewModel = self.viewModel
        return (StampBottomSheetViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: StampBottomSheetViewModel {
        return StampBottomSheetViewModel(
            selectedStamp: selectedStamp,
            selectedTemp: selectedTemp
        )
    }

    var selectedStamp: LogStamp2
    var selectedTemp: String

    init(
        selectedStamp: LogStamp2,
        selectedTemp: String
    ) {
        self.selectedStamp = selectedStamp
        self.selectedTemp = selectedTemp
    }
}
