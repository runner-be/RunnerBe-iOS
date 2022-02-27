//
//  EditInfoComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import Foundation
import NeedleFoundation

protocol EditInfoDependency: Dependency {}

final class EditInfoComponent: Component<EditInfoDependency> {
    var scene: (VC: UIViewController, VM: EditInfoViewModel) {
        let viewModel = self.viewModel
        return (EditInfoViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: EditInfoViewModel {
        return EditInfoViewModel()
    }
}
