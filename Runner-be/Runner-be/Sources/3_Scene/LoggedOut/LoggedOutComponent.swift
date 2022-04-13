//
//  0__LoggedOutComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import Foundation
import NeedleFoundation

protocol LoggedOutDependency: Dependency {}

class LoggedOutComponent: Component<LoggedOutDependency> {
    var scene: (VC: UIViewController, VM: LoggedOutViewModel) {
        let viewModel = self.viewModel
        return (LoggedOutViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: LoggedOutViewModel {
        return LoggedOutViewModel()
    }
}
