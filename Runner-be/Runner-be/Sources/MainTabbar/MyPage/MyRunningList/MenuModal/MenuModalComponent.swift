//
//  MenuModalComponent.swift
//  Runner-be
//
//  Created by 김창규 on 9/6/24.
//

import UIKit

final class MenuModalComponent {
    var scene: (VC: UIViewController, VM: MenuModalViewModel) {
        let viewModel = self.viewModel
        return (MenuModalViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: MenuModalViewModel {
        return MenuModalViewModel()
    }
}
