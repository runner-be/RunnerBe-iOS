//
//  EmailCertificationInitModalComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import Foundation
import NeedleFoundation

protocol SelectDateModalDependency: Dependency {}

final class SelectDateModalComponent: Component<SelectDateModalDependency> {
    var scene: (VC: UIViewController, VM: SelectDateModalViewModel) {
        let viewModel = viewModel
        return (SelectDateModalViewController(viewModel: viewModel), viewModel)
    }

    private var viewModel: SelectDateModalViewModel {
        return SelectDateModalViewModel()
    }
}
