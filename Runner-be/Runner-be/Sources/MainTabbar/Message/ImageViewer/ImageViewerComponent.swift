//
//  ImageViewerComponent.swift
//  Runner-be
//
//  Created by 김창규 on 7/11/24.
//

import UIKit

final class ImageViewerComponent {
    var scene: (VC: ImageViewerViewController, VM: ImageViewerViewModel) {
        let viewModel = self.viewModel
        return (ImageViewerViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: ImageViewerViewModel {
        return ImageViewerViewModel(image: image)
    }

    private var image: UIImage

    init(image: UIImage) {
        self.image = image
    }
}
