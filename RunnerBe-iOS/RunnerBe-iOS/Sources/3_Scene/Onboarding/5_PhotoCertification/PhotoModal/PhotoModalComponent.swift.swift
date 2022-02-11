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
    var photoModal: (VC: UIViewController, VM: PhotoModalViewModel) {
        let viewModel = photoModalViewModel
        return (PhotoModalViewController(viewModel: viewModel), viewModel)
    }

    private var photoModalViewModel: PhotoModalViewModel {
        return PhotoModalViewModel()
    }
}
