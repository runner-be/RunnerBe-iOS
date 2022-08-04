//
//  TimeExpiredModal.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/23.
//

import Foundation
import NeedleFoundation

protocol ManageTimeExpiredModalDependency: Dependency {}

final class ManageTimeExpiredModalComponent: Component<ManageTimeExpiredModalDependency> {
    var scene: (VC: UIViewController, VM: ManageTimeExpiredModalViewModel) {
        let viewModel = self.viewModel
        return (ManagedTimeExpiredViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: ManageTimeExpiredModalViewModel {
        return ManageTimeExpiredModalViewModel()
    }
}
