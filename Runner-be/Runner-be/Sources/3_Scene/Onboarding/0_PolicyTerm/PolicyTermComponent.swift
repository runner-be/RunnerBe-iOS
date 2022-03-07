//
//  PolicyTermComponenet.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/07.
//

import Foundation
import NeedleFoundation

protocol PolicyTermDependency: Dependency {
    var loginKeyChainService: LoginKeyChainService { get }
    var signupKeyChainService: SignupKeyChainService { get }
}

final class PolicyTermComponent: Component<PolicyTermDependency> {
    var scene: (VC: UIViewController, VM: PolicyTermViewModel) {
        let viewModel = viewModel
        return (PolicyTermViewController(viewModel: viewModel), viewModel)
    }

    private var viewModel: PolicyTermViewModel {
        return PolicyTermViewModel()
    }

    var birthComponent: BirthComponent {
        return BirthComponent(parent: self)
    }

    var onboardingCancelModalComponent: OnboardingCancelModalComponent {
        return OnboardingCancelModalComponent(parent: self)
    }

    func policyDetailComponent(type: PolicyType, modal: Bool) -> PolicyDetailComponent {
        return PolicyDetailComponent(parent: self, policyType: type, modal: modal)
    }
}
