//
//  RegisterRunningPaceComponent.swift
//  Runner-be
//
//  Created by 이유리 on 2/12/24.
//

import UIKit

final class RegisterRunningPaceComponent {
    var scene: (VC: UINavigationController, VM: RegisterRunningPaceViewModel) {
        let viewModel = self.viewModel
        let navigationController = UINavigationController(rootViewController: RegisterRunningPaceViewController(viewModel: viewModel))
        navigationController.setNavigationBarHidden(true, animated: false)

        return (navigationController, viewModel)
    }

    var viewModel: RegisterRunningPaceViewModel {
        return RegisterRunningPaceViewModel()
    }

    func confirmModal(pace: String) -> ConfirmModalComponent {
        return ConfirmModalComponent(pace: pace)
    }
}
