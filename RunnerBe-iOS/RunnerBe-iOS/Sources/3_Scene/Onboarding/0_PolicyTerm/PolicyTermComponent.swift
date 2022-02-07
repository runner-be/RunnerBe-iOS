//
//  PolicyTermComponenet.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/07.
//

import Foundation
import NeedleFoundation

protocol PolicyTermDependency: Dependency {}

final class PolicyTermComponent: Component<PolicyTermDependency> {
    var policyTermViewController: UIViewController {
        return PolicyTermViewController(viewModel: policyTermViewModel)
    }

    var policyTermViewModel: PolicyTermViewModel {
        return shared { PolicyTermViewModel() }
    }

    var birthComponent: BirthComponent {
        return BirthComponent(parent: self)
    }
}
