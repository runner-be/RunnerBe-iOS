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
    var emailCertificationViewController: UIViewController {
        return EmailCertificationViewController(viewModel: emailCertificationViewModel)
    }

    var emailCertificationViewModel: EmailCertificationViewModel {
        return shared { EmailCertificationViewModel() }
    }
}
