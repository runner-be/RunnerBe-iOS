//
//  RunningTagModalComponent.swift
//  Runner-be
//
//  Created by 김신우 on 2022/07/27.
//

import UIKit

final class RunningTagModalComponent {
    var scene: (VC: UIViewController, VM: RunningTagModalViewModel) {
        let viewModel = self.viewModel
        return (RunningTagModalViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: RunningTagModalViewModel {
        return RunningTagModalViewModel()
    }
}
