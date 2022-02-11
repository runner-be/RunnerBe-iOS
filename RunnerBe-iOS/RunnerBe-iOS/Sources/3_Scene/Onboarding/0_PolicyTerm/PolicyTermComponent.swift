//
//  PolicyTermComponenet.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/07.
//

import Foundation
import NeedleFoundation

protocol PolicyTermDependency: Dependency {}

final class PolicyTermComponent: Component<PolicyTermDependency> {
    var policyTerm: (VC: UIViewController, VM: PolicyTermViewModel) {
        let viewModel = policyTermViewModel
        return (PolicyTermViewController(viewModel: viewModel), viewModel)
    }

    private var policyTermViewModel: PolicyTermViewModel {
        return PolicyTermViewModel()
    }

    var birthComponent: BirthComponent {
        return BirthComponent(parent: self)
    }

    var onboardingCancelModalComponent: OnboardingCancelModalComponent {
        return OnboardingCancelModalComponent(parent: self)
    }
}
