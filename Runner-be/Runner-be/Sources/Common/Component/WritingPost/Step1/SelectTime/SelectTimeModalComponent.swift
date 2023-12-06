//
//  SelectTimeModalComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import UIKit

final class SelectTimeModalComponent {
    var scene: (VC: UIViewController, VM: SelectTimeModalViewModel) {
        let viewModel = viewModel
        return (SelectTimeModalViewController(viewModel: viewModel), viewModel)
    }

    private var viewModel: SelectTimeModalViewModel {
        return SelectTimeModalViewModel(timeString: timeString)
    }

    private var timeString: String

    init(timeString: String) {
        self.timeString = timeString
    }
}
