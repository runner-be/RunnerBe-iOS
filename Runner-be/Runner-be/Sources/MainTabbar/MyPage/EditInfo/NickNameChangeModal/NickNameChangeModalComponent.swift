//
//  NickNameChangeModalComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import UIKit

final class NickNameChangeModalComponent {
    var scene: (VC: UIViewController, VM: NickNameChangeModalViewModel) {
        let viewModel = self.viewModel
        return (NickNameChangeModalViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: NickNameChangeModalViewModel {
        return NickNameChangeModalViewModel()
    }
}
