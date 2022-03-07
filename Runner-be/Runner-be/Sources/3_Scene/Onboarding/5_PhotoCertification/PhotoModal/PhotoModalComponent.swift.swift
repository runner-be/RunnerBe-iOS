//
//  PhotoModalComponent.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/09.
//

import Foundation
import NeedleFoundation

protocol PhotoModalDependency: Dependency {}

final class PhotoModalComponent: Component<PhotoModalDependency> {
    var scene: (VC: UIViewController, VM: PhotoModalViewModel) {
        let viewModel = viewModel
        return (PhotoModalViewController(viewModel: viewModel), viewModel)
    }

    private var viewModel: PhotoModalViewModel {
        return PhotoModalViewModel()
    }
}
