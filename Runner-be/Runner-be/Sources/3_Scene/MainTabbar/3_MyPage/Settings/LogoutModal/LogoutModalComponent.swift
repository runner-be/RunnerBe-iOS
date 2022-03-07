//
//  LogoutModalComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import Foundation
import NeedleFoundation

protocol LogoutModalDependency: Dependency {}

final class LogoutModalComponent: Component<LogoutModalDependency> {
    var scene: (VC: UIViewController, VM: LogoutModalViewModel) {
        let viewModel = self.viewModel
        return (LogoutModalViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: LogoutModalViewModel {
        return LogoutModalViewModel()
    }
}
