//
//  MakerComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import UIKit

final class MakerComponent {
    var scene: (VC: UIViewController, VM: MakerViewModel) {
        let viewModel = self.viewModel
        return (MakerViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: MakerViewModel {
        return MakerViewModel()
    }
}
