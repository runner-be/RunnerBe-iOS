//
//  SelectDateModalComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import UIKit

final class SelectDateModalComponent {
    var scene: (VC: UIViewController, VM: SelectDateModalViewModel) {
        let viewModel = viewModel
        return (SelectDateModalViewController(viewModel: viewModel), viewModel)
    }

    private var viewModel: SelectDateModalViewModel {
        return SelectDateModalViewModel(dateInterval: dateInterval)
    }

    private var dateInterval: Double

    init(dateInterval: Double) {
        self.dateInterval = dateInterval
    }
}
