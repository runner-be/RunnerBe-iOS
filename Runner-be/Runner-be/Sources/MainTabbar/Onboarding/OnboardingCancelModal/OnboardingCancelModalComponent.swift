//
//  OnboardingCancelModalComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import UIKit

final class OnboardingCancelModalComponent {
    var scene: (VC: UIViewController, VM: OnboardingCancelModalViewModel) {
        let viewModel = self.viewModel
        return (OnboardingCancelModalViewController(viewModel: viewModel), viewModel)
    }

    private var viewModel: OnboardingCancelModalViewModel {
        return OnboardingCancelModalViewModel()
    }
}
