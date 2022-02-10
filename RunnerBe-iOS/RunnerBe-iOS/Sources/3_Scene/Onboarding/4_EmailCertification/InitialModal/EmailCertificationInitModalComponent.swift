//
//  EmailCertificationInitModalComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import Foundation
import NeedleFoundation

protocol EmailCertificationInitModalDependency: Dependency {}

final class EmailCertificationInitModalComponent: Component<EmailCertificationInitModalDependency> {
    var emailCertificationInitModalViewController: UIViewController {
        return EmailCertificationInitModalViewController(viewModel: emailCertificationInitModalViewModel)
    }

    var emailCertificationInitModalViewModel: EmailCertificationInitModalViewModel {
        return shared { EmailCertificationInitModalViewModel() }
    }
}
