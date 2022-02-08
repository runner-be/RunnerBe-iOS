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
    var selectJobGroupViewController: UIViewController {
        return SelectJobGroupViewController(viewModel: selectJobGroupViewModel)
    }

    var selectJobGroupViewModel: SelectJobGroupViewModel {
        return shared { SelectJobGroupViewModel() }
    }

    var emailCertificationComponent: EmailCertificationComponent {
        return EmailCertificationComponent(parent: self)
    }
}
