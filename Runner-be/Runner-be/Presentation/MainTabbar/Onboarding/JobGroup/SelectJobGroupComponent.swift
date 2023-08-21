//
//  SelectJobGroupComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import UIKit

final class SelectJobGroupComponent {
    var scene: (VC: UIViewController, VM: SelectJobGroupViewModel) {
        let viewModel = viewModel
        return (SelectJobGroupViewController(viewModel: viewModel), viewModel)
    }

    private var viewModel: SelectJobGroupViewModel {
        return SelectJobGroupViewModel()
    }

    var onboardingCancelModalComponent: OnboardingCancelModalComponent {
        return OnboardingCancelModalComponent()
    }

    var onboardingCompleteComponent: OnboardingCompletionComponent {
        return OnboardingCompletionComponent()
    }
}
