//
//  PhotoCertificationCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import Foundation
import RxSwift

enum PhotoCertificationResult {}

final class PhotoCertificationCoordinator: BasicCoordinator<PhotoCertificationResult> {
    var component: PhotoCertificationComponent

    init(component: PhotoCertificationComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start() {
        navController.pushViewController(component.photoCertificationViewController, animated: true)

        component.photoCertificationViewModel
            .routes.photoModal
            .flatMap { self.presentPhotoModal() }
            .subscribe(component.photoCertificationViewModel.routeInputs.photoModal)
            .disposed(by: disposeBag)
    }

    private func presentPhotoModal() -> Observable<ImagePickerType?> {
        let comp = component.photoModalComponent
        let coord = PhotoModalCoordinator(component: comp, navController: navController)

        return coordinate(coordinator: coord)
            .flatMap { coordResult -> Observable<ImagePickerType?> in
                defer { self.release(coordinator: coord) }
                switch coordResult {
                case .takePhoto:
                    return .just(.camera)
                case .choosePhoto:
                    return .just(.library)
                case .cancel:
                    return .just(nil)
                }
            }
    }
}
