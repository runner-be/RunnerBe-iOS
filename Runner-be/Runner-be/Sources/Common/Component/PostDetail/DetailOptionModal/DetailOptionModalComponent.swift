//
//  DetailOptionModalComponent.swift
//  Runner-be
//
//  Created by 김신우 on 2022/08/08.
//

import UIKit

final class DetailOptionModalComponent {
    var scene: (VC: UIViewController, VM: DetailOptionModalViewModel) {
        let viewModel = self.viewModel
        return (DetailOptionModalViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: DetailOptionModalViewModel {
        return DetailOptionModalViewModel()
    }
}
