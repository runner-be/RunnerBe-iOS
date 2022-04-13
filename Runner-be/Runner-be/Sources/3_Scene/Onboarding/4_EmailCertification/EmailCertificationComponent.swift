//
//  EmailCertificationComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import Foundation
import NeedleFoundation

protocol EmailCertificationDependency: Dependency {}

final class EmailCertificationComponent: Component<EmailCertificationDependency> {
    var scene: (VC: UIViewController, VM: EmailCertificationViewModel) {
        return shared {
            let viewModel = viewModel
            return (EmailCertificationViewController(viewModel: viewModel), viewModel)
        }
    }

    private var viewModel: EmailCertificationViewModel {
        return EmailCertificationViewModel()
    }

    var idCardCertificationComponent: PhotoCertificationComponent {
        return PhotoCertificationComponent(parent: self)
    }

    var onboardingCancelModalComponent: OnboardingCancelModalComponent {
        return OnboardingCancelModalComponent(parent: self)
    }

    var onboardingCompletionComponent: OnboardingCompletionComponent {
        return OnboardingCompletionComponent(parent: self)
    }

    var initModalComponent: EmailCertificationInitModalComponent {
        return EmailCertificationInitModalComponent(parent: self)
    }
}
