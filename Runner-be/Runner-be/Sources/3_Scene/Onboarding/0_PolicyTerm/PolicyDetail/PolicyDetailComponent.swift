//
//  PolicyDetailComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import Foundation
import NeedleFoundation

protocol PolicyDetailDependency: Dependency {}

final class PolicyDetailComponent: Component<PolicyDetailDependency> {
    var scene: (VC: UIViewController, VM: PolicyDetailViewModel) {
        let viewModel = self.viewModel
        return (PolicyDetailViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: PolicyDetailViewModel {
        return PolicyDetailViewModel(policyType: policyType, modal: isModal)
    }

    init(parent: Scope, policyType: PolicyType, modal: Bool) {
        isModal = modal
        self.policyType = policyType
        super.init(parent: parent)
    }

    private(set) var isModal: Bool
    private var policyType: PolicyType
}
