//
//  0__LoggedOutComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import UIKit

final class LoginComponent {
    var scene: (VC: UIViewController, VM: LoginViewModel) {
        let viewModel = self.viewModel
        return (LoginViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: LoginViewModel {
        return LoginViewModel()
    }
}
