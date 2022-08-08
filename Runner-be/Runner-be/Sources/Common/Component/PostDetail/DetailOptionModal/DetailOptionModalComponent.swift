//
//  DetailOptionModalComponent.swift
//  Runner-be
//
//  Created by 김신우 on 2022/08/08.
//

import Foundation
import NeedleFoundation

protocol DetailOptionModalDependency: Dependency {}

final class DetailOptionModalComponent: Component<DetailOptionModalDependency> {
    var scene: (VC: UIViewController, VM: DetailOptionModalViewModel) {
        let viewModel = self.viewModel
        return (DetailOptionModalViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: DetailOptionModalViewModel {
        return DetailOptionModalViewModel()
    }
}
