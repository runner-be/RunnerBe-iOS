//
//  EmailCertificationInitModalComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import Foundation
import NeedleFoundation

protocol SelectTimeModalDependency: Dependency {}

final class SelectTimeModalComponent: Component<SelectTimeModalDependency> {
    var scene: (VC: UIViewController, VM: SelectTimeModalViewModel) {
        let viewModel = viewModel
        return (SelectTimeModalViewController(viewModel: viewModel), viewModel)
    }

    private var viewModel: SelectTimeModalViewModel {
        return SelectTimeModalViewModel()
    }
}
