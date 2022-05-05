//
//  BirthComponent.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/07.
//

import Foundation

import Foundation
import NeedleFoundation

protocol BirthDependency: Dependency {}

final class BirthComponent: Component<BirthDependency> {
    var scene: (VC: UIViewController, VM: BirthViewModel) {
        let viewModel = viewModel
        return (BirthViewController(viewModel: viewModel), viewModel)
    }

    private var viewModel: BirthViewModel {
        return BirthViewModel()
    }

    var selectGenderComponent: SelectGenderComponent {
        return SelectGenderComponent(parent: self)
    }

    var onboardingCancelModalComponent: OnboardingCancelModalComponent {
        return OnboardingCancelModalComponent(parent: self)
    }
}