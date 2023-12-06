//
//  BirthComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/07.
//

import UIKit

final class BirthComponent {
    var scene: (VC: UIViewController, VM: BirthViewModel) {
        let viewModel = viewModel
        return (BirthViewController(viewModel: viewModel), viewModel)
    }

    private var viewModel: BirthViewModel {
        return BirthViewModel()
    }

    var selectGenderComponent: SelectGenderComponent {
        return SelectGenderComponent()
    }

    var onboardingCancelModalComponent: OnboardingCancelModalComponent {
        return OnboardingCancelModalComponent()
    }
}
