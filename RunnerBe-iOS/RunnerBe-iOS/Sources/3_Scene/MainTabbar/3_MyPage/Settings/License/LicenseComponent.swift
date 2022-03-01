//
//  LicenseComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/02.
//

import Foundation
import NeedleFoundation

protocol LicenseDependency: Dependency {}

final class LicenseComponent: Component<LicenseDependency> {
    var scene: (VC: UIViewController, VM: LicenseViewModel) {
        let viewModel = self.viewModel
        let vc = LicenseViewController(fileNamed: "Pods-RunnerBe-iOS-acknowledgements")
        vc.viewModel = viewModel
        return (vc, viewModel)
    }

    var viewModel: LicenseViewModel {
        return LicenseViewModel()
    }
}
