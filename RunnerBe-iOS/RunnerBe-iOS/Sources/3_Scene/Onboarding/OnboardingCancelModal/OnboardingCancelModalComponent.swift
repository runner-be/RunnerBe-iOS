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
    var onboardingCancelModalViewController: UIViewController {
        return OnboardingCancelModalViewController(viewModel: onboardingCancelModalViewModel)
    }

    var onboardingCancelModalViewModel: OnboardingCancelModalViewModel {
        return shared { OnboardingCancelModalViewModel() }
    }
}
