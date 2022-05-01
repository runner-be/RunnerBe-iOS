//
//  OnboardingCompletionComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import Foundation
import NeedleFoundation

protocol OnboardingCompletionDependency: Dependency {}

final class OnboardingCompletionComponent: Component<OnboardingCompletionDependency> {
    var scene: (VC: UIViewController, VM: OnboardingCompletionViewModel) {
        let viewModel = self.viewModel
        return (OnboardingCompletionViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: OnboardingCompletionViewModel {
        return OnboardingCompletionViewModel()
    }
}
