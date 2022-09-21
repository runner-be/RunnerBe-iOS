//
//  DeleteConfirmModalComponent.swift
//  Runner-be
//
//  Created by 김신우 on 2022/08/08.
//

import UIKit

final class DeleteConfirmModalComponent {
    var scene: (VC: UIViewController, VM: DeleteConfirmModalViewModel) {
        let viewModel = self.viewModel
        return (DeleteConfirmModalViewController(viewModel: viewModel), viewModel)
    }

    private var viewModel: DeleteConfirmModalViewModel {
        return DeleteConfirmModalViewModel()
    }
}
