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
    var photoModalViewController: UIViewController {
        return PhotoModalViewController(viewModel: photoModalViewModel)
    }

    var photoModalViewModel: PhotoModalViewModel {
        return shared { PhotoModalViewModel() }
    }
}
