//
//  SettingsComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import Foundation
import NeedleFoundation

protocol SettingsDependency: Dependency {
    var userAPIService: UserAPIService { get }
}

final class SettingsComponent: Component<SettingsDependency> {
    var scene: (VC: UIViewController, VM: SettingsViewModel) {
        let viewModel = self.viewModel
        return (SettingsViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: SettingsViewModel {
        return SettingsViewModel(userAPIService: dependency.userAPIService)
    }

    var makerComponent: MakerComponent {
        return MakerComponent(parent: self)
    }

    var logoutModalComponent: LogoutModalComponent {
        return LogoutModalComponent(parent: self)
    }

    var licenseComponent: LicenseComponent {
        return LicenseComponent(parent: self)
    }

    var signoutModalComponent: SignoutModalComponent {
        return SignoutModalComponent(parent: self)
    }

    var signoutCompletionModalComponent: SignoutCompletionModalComponent {
        return SignoutCompletionModalComponent(parent: self)
    }

    func policyDetailComponent(type: PolicyType, modal: Bool) -> PolicyDetailComponent {
        return PolicyDetailComponent(parent: self, policyType: type, modal: modal)
    }
}
