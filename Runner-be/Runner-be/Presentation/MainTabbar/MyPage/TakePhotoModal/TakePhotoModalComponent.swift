//
//  TakePhotoModalComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import UIKit

final class TakePhotoModalComponent {
    var scene: (VC: UIViewController, VM: TakePhotoModalViewModel) {
        let viewModel = self.viewModel
        return (TakePhotoModalViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: TakePhotoModalViewModel {
        return TakePhotoModalViewModel()
    }
}
