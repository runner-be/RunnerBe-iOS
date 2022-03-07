//
//  WaitCertificationComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import Foundation
import NeedleFoundation

protocol WaitCertificationDependency: Dependency {}

final class WaitCertificationComponent: Component<WaitCertificationDependency> {
    var scene: (VC: UIViewController, VM: WaitCertificationViewModel) {
        let viewModel = self.viewModel
        return (WaitCertificationViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: WaitCertificationViewModel {
        return WaitCertificationViewModel()
    }
}
