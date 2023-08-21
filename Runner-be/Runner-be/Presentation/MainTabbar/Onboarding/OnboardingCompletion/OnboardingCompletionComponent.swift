//
//  OnboardingCompletionComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import UIKit

final class OnboardingCompletionComponent {
    var scene: (VC: UIViewController, VM: OnboardingCompletionViewModel) {
        let viewModel = self.viewModel
        return (OnboardingCompletionViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: OnboardingCompletionViewModel {
        return OnboardingCompletionViewModel()
    }
}
