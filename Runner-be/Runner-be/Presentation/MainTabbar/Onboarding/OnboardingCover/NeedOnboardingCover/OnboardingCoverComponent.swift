//
//  OnboardingCoverComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/04.
//

import UIKit

final class OnboardingCoverComponent {
    var scene: (VC: UIViewController, VM: OnboardingCoverViewModel) {
        let viewModel = self.viewModel
        return (OnboardingCoverViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: OnboardingCoverViewModel {
        return OnboardingCoverViewModel()
    }

    var policyTermComponent: PolicyTermComponent {
        return PolicyTermComponent()
    }
}
