//
//  SelectJobGroupComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import Foundation
import NeedleFoundation

protocol SelectJobGroupDependency: Dependency {}

final class SelectJobGroupComponent: Component<SelectJobGroupDependency> {
    var scene: (VC: UIViewController, VM: SelectJobGroupViewModel) {
        let viewModel = viewModel
        return (SelectJobGroupViewController(viewModel: viewModel), viewModel)
    }

    private var viewModel: SelectJobGroupViewModel {
        return SelectJobGroupViewModel()
    }

    var emailCertificationComponent: EmailCertificationComponent {
        return EmailCertificationComponent(parent: self)
    }

    var onboardingCancelModalComponent: OnboardingCancelModalComponent {
        return OnboardingCancelModalComponent(parent: self)
    }
}
