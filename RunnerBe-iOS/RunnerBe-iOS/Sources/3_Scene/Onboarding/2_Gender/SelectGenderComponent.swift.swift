//
//  SelectGenderComponent.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import Foundation
import NeedleFoundation

protocol SelectGenderDependency: Dependency {
    var loginKeyChainService: LoginKeyChainService { get }
    var signupKeyChainService: SignupKeyChainService { get }
}

final class SelectGenderComponent: Component<SelectGenderDependency> {
    var scene: (VC: UIViewController, VM: SelectGenderViewModel) {
        let viewModel = viewModel
        return (SelectGenderViewController(viewModel: viewModel), viewModel)
    }

    private var viewModel: SelectGenderViewModel {
        return SelectGenderViewModel(signupKeyChainService: dependency.signupKeyChainService)
    }

    var selectJobGroupCoord: SelectJobGroupComponent {
        return SelectJobGroupComponent(parent: self)
    }

    var onboardingCancelModalComponent: OnboardingCancelModalComponent {
        return OnboardingCancelModalComponent(parent: self)
    }
}
