//
//  RegisterRunningPaceCancelModalComponent.swift
//  Runner-be
//
//  Created by 이유리 on 4/16/24.
//

import UIKit

final class RegisterRunningPaceCancelModalComponent {
    var scene: (VC: UIViewController, VM: RegisterRunningPaceCancelModalViewModel) {
        let viewModel = self.viewModel

        return (RegisterRunningPaceCancelModalViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: RegisterRunningPaceCancelModalViewModel {
        return RegisterRunningPaceCancelModalViewModel()
    }
}
