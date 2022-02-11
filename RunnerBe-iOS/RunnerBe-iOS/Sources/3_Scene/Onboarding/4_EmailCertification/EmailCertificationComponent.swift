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
    var emailCertification: (VC: UIViewController, VM: EmailCertificationViewModel) {
        let viewModel = emailCertificationViewModel
        return (EmailCertificationViewController(viewModel: viewModel), viewModel)
    }

    private var emailCertificationViewModel: EmailCertificationViewModel {
        return EmailCertificationViewModel()
    }

    var photoCertificationComponent: PhotoCertificationComponent {
        return PhotoCertificationComponent(parent: self)
    }

    var onboardingCancelModalComponent: OnboardingCancelModalComponent {
        return OnboardingCancelModalComponent(parent: self)
    }

    var initModalComponent: EmailCertificationInitModalComponent {
        return EmailCertificationInitModalComponent(parent: self)
    }
}
