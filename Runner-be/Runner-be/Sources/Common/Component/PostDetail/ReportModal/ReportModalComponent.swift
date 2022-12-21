//
//  ReportModalComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/05.
//

import UIKit

final class ReportModalComponent {
    var scene: (VC: UIViewController, VM: ReportModalViewModel) {
        let viewModel = self.viewModel
        return (ReportModalViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: ReportModalViewModel {
        return ReportModalViewModel()
    }
}
