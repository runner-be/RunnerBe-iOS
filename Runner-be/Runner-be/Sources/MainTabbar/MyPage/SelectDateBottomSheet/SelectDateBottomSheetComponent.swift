//
//  SelectDateBottomSheetComponent.swift
//  Runner-be
//
//  Created by 김창규 on 8/28/24.
//

import UIKit

final class SelectDateBottomSheetComponent {
    var scene: (VC: UIViewController, VM: SelectDateBottomSheetViewModel) {
        let viewModel = self.viewModel
        return (SelectDateBottomSheetViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: SelectDateBottomSheetViewModel {
        return SelectDateBottomSheetViewModel(year: year, month: month)
    }

    var year: Int
    var month: Int

    init(year: Int, month: Int) {
        self.year = year
        self.month = month
    }
}
