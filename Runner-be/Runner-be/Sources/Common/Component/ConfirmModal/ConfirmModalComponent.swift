//
//  ConfirmModalComponent.swift
//  Runner-be
//
//  Created by 이유리 on 2/16/24.
//

import UIKit

final class ConfirmModalComponent {
    var scene: (VC: ConfirmModalViewController, VM: ConfirmModalViewModel) {
        let viewModel = self.viewModel
        return (ConfirmModalViewController(viewModel: viewModel, pace: pace), viewModel)
    }

    var viewModel: ConfirmModalViewModel = .init()

    var pace: String

    init(pace: String) {
        self.pace = pace
    }
}
