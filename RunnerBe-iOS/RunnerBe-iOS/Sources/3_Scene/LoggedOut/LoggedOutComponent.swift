//
//  0__LoggedOutComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import Foundation
import NeedleFoundation

protocol LoggedOutDependency: Dependency {
    var loginService: LoginService { get }
}

class LoggedOutComponent: Component<LoggedOutDependency> {
    var scene: (VC: UIViewController, VM: LoggedOutViewModel) {
        let viewModel = self.viewModel
        return (LoggedOutViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: LoggedOutViewModel {
        return LoggedOutViewModel(loginService: dependency.loginService, signupKeyChainService: signupKeyChainService)
    }

    var policyTermComponent: PolicyTermComponent {
        return PolicyTermComponent(parent: self)
    }

    var signupKeyChainService: SignupKeyChainService {
        return shared { BasicSignupKeyChainService() }
    }
}
