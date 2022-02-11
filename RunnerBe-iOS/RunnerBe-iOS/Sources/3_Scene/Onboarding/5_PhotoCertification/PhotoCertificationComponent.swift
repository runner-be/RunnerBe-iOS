//
//  PhotoCertificationComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import Foundation
import NeedleFoundation

protocol PhotoCertificationDependency: Dependency {}

final class PhotoCertificationComponent: Component<PhotoCertificationDependency> {
    var scene: (VC: UIViewController, VM: PhotoCertificationViewModel) {
        let viewModel = viewModel
        return (PhotoCertificationViewController(viewModel: viewModel), viewModel)
    }

    private var viewModel: PhotoCertificationViewModel {
        return PhotoCertificationViewModel()
    }

    var photoModalComponent: PhotoModalComponent {
        return PhotoModalComponent(parent: self)
    }

    var onboardingCancelModalComponent: OnboardingCancelModalComponent {
        return OnboardingCancelModalComponent(parent: self)
    }
}
