//
//  ReportModalComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/05.
//

import Foundation
import NeedleFoundation

protocol ReportModalDependency: Dependency {}

final class ReportModalComponent: Component<ReportModalDependency> {
    var scene: (VC: UIViewController, VM: ReportModalViewModel) {
        let viewModel = self.viewModel
        return (ReportModalViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: ReportModalViewModel {
        return ReportModalViewModel()
    }
}
