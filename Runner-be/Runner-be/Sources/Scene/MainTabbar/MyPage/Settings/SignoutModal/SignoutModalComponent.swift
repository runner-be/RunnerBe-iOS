//
//  SignoutModalComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/06.
//

import Foundation
import NeedleFoundation

protocol SignoutModalDependency: Dependency {}

final class SignoutModalComponent: Component<SignoutModalDependency> {
    var scene: (VC: UIViewController, VM: SignoutModalViewModel) {
        let viewModel = self.viewModel
        return (SignoutModalViewController(viewModel: viewModel), viewModel)
    }

    private var viewModel: SignoutModalViewModel {
        return SignoutModalViewModel()
    }
}
