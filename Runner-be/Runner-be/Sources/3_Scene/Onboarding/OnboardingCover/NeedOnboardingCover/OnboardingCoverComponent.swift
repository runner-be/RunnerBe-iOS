//
//  OnboardingCoverComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/04.
//

import Foundation
import NeedleFoundation

protocol OnboardingCoverDependency: Dependency {
    var loginKeyChainService: LoginKeyChainService { get }
    var signupKeyChainService: SignupKeyChainService { get }
}

final class OnboardingCoverComponent: Component<OnboardingCoverDependency> {
    var scene: (VC: UIViewController, VM: OnboardingCoverViewModel) {
        let viewModel = self.viewModel
        return (OnboardingCoverViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: OnboardingCoverViewModel {
        return OnboardingCoverViewModel()
    }

    var policyTermComponent: PolicyTermComponent {
        return PolicyTermComponent(parent: self)
    }
}
