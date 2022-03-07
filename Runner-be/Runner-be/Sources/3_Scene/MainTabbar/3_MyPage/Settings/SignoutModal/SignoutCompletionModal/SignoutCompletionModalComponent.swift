//
//  SignoutCompletionModalComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/06.
//

import Foundation
import NeedleFoundation

protocol SignoutCompletionModalDependency: Dependency {}

final class SignoutCompletionModalComponent: Component<SignoutCompletionModalDependency> {
    var scene: (VC: UIViewController, VM: SignoutCompletionModalViewModel) {
        let viewModel = self.viewModel
        return (SignoutCompletionModalViewController(viewModel: viewModel), viewModel)
    }

    private var viewModel: SignoutCompletionModalViewModel {
        return SignoutCompletionModalViewModel()
    }
}
