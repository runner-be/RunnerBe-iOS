//
//  TakePhotoModalComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import Foundation
import NeedleFoundation

protocol TakePhotoModalDependency: Dependency {}

final class TakePhotoModalComponent: Component<TakePhotoModalDependency> {
    var scene: (VC: UIViewController, VM: TakePhotoModalViewModel) {
        let viewModel = self.viewModel
        return (TakePhotoModalViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: TakePhotoModalViewModel {
        return TakePhotoModalViewModel()
    }
}
