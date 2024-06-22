//
//  RegisterRunningPaceConfirmModalComponent.swift
//  Runner-be
//
//  Created by 이유리 on 2/16/24.
//

import UIKit

final class RegisterRunningPaceConfirmModalComponent {
    var scene: (VC: UIViewController, VM: RegisterRunningPaceConfirmModalViewModel) {
        let viewModel = self.viewModel
        return (RegisterRunningPaceConfirmModalViewController(viewModel: viewModel, pace: pace), viewModel)
    }

    var viewModel: RegisterRunningPaceConfirmModalViewModel = .init()

    var pace: String

    init(pace: String) {
        self.pace = pace
    }
}
