//
//  OnboardingCancelModalComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import Foundation
import NeedleFoundation

protocol OnboardingCancelModalDependency: Dependency {}

final class OnboardingCancelModalComponent: Component<OnboardingCancelModalDependency> {
    var onboardingCancelModal: (VC: UIViewController, VM: OnboardingCancelModalViewModel) {
        let viewModel = onboardingCancelModalViewModel
        return (OnboardingCancelModalViewController(viewModel: viewModel), viewModel)
    }

    private var onboardingCancelModalViewModel: OnboardingCancelModalViewModel {
        return OnboardingCancelModalViewModel()
    }
}
