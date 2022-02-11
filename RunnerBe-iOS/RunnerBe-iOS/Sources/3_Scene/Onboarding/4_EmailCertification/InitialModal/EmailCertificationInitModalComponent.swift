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
    var emailCertificationInitModal: (VC: UIViewController, VM: EmailCertificationInitModalViewModel) {
        let viewModel = emailCertificationInitModalViewModel
        return (EmailCertificationInitModalViewController(viewModel: viewModel), viewModel)
    }

    private var emailCertificationInitModalViewModel: EmailCertificationInitModalViewModel {
        return EmailCertificationInitModalViewModel()
    }
}
