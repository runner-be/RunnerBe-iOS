//
//  MakerComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import Foundation

import Foundation
import NeedleFoundation

protocol MakerDependency: Dependency {}

final class MakerComponent: Component<MakerDependency> {
    var scene: (VC: UIViewController, VM: MakerViewModel) {
        let viewModel = self.viewModel
        return (MakerViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: MakerViewModel {
        return MakerViewModel()
    }
}
