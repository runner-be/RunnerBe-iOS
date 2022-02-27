//
//  SettingsComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import Foundation
import NeedleFoundation

protocol SettingsDependency: Dependency {}

final class SettingsComponent: Component<SettingsDependency> {
    var scene: (VC: UIViewController, VM: SettingsViewModel) {
        let viewModel = self.viewModel
        return (SettingsViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: SettingsViewModel {
        return SettingsViewModel()
    }
}
