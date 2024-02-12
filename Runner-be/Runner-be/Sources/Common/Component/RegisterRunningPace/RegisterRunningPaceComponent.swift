//
//  RegisterRunningPaceComponent.swift
//  Runner-be
//
//  Created by 이유리 on 2/12/24.
//

import UIKit

final class RegisterRunningPaceComponent {
    var scene: (VC: UIViewController, VM: RegisterRunningPaceViewModel) {
        let viewModel = self.viewModel
        return (RegisterRunningPaceViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: RegisterRunningPaceViewModel {
        return RegisterRunningPaceViewModel()
    }
}
