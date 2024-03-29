//
//  SettingsComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import UIKit

final class SettingsComponent {
    var scene: (VC: UIViewController, VM: SettingsViewModel) {
        let viewModel = self.viewModel
        return (SettingsViewController(viewModel: viewModel, isOn: isOn), viewModel)
    }

    lazy var viewModel = SettingsViewModel()
    var isOn: String

    init(isOn: String) {
        self.isOn = isOn
    }

    var makerComponent: MakerComponent {
        return MakerComponent()
    }

    var logoutModalComponent: LogoutModalComponent {
        return LogoutModalComponent()
    }

    var signoutModalComponent: SignoutModalComponent {
        return SignoutModalComponent()
    }

    var signoutCompletionModalComponent: SignoutCompletionModalComponent {
        return SignoutCompletionModalComponent()
    }

    func policyDetailComponent(type: PolicyType, modal: Bool) -> PolicyDetailComponent {
        return PolicyDetailComponent(policyType: type, modal: modal)
    }
}
