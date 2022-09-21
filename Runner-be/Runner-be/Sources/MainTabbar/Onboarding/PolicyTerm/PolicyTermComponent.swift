//
//  PolicyTermComponenet.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/07.
//

import UIKit

final class PolicyTermComponent {
    var scene: (VC: UIViewController, VM: PolicyTermViewModel) {
        let viewModel = viewModel
        return (PolicyTermViewController(viewModel: viewModel), viewModel)
    }

    private var viewModel: PolicyTermViewModel {
        return PolicyTermViewModel()
    }

    var birthComponent: BirthComponent {
        return BirthComponent()
    }

    var onboardingCancelModalComponent: OnboardingCancelModalComponent {
        return OnboardingCancelModalComponent()
    }

    func policyDetailComponent(type: PolicyType, modal: Bool) -> PolicyDetailComponent {
        return PolicyDetailComponent(policyType: type, modal: modal)
    }
}
