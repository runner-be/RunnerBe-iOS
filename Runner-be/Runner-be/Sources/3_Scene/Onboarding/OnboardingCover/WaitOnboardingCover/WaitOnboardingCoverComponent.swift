//
//  WaitOnboardingCoverComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/05.
//

import Foundation
import NeedleFoundation

protocol WaitOnboardingCoverDependency: Dependency {}

final class WaitOnboardingCoverComponent: Component<OnboardingCoverDependency> {
    var scene: (VC: UIViewController, VM: WaitOnboardingCoverViewModel) {
        let viewModel = self.viewModel
        return (WaitOnboardingViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: WaitOnboardingCoverViewModel {
        return WaitOnboardingCoverViewModel()
    }
}
