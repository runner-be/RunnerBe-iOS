//
//  TimeExpiredModal.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/23.
//

import UIKit

final class ManageTimeExpiredModalComponent {
    var scene: (VC: UIViewController, VM: ManageTimeExpiredModalViewModel) {
        let viewModel = self.viewModel
        return (ManagedTimeExpiredViewController(), viewModel)
    }

    var viewModel: ManageTimeExpiredModalViewModel {
        return ManageTimeExpiredModalViewModel()
    }
}
