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

    private func presentPhotoModal() -> Observable<Data?> {
        let comp = component.photoModalComponent
        let coord = PhotoModalCoordinator(component: comp, navController: navController)

        return coordinate(coordinator: coord)
            .flatMap { modalResult -> Observable<Data?> in
                defer { self.release(coordinator: coord) }
                switch modalResult {
                case .takePhoto:
                    return self.presentTakePhoto()
                case .choosePhoto:
                    return self.presentChoosePhoto()
                case .cancel:
                    return .just(nil)
                }
            }
    }

    private func presentTakePhoto() -> Observable<Data?> {
        return .just(nil)
    }

    private func presentChoosePhoto() -> Observable<Data?> {
        return .just(nil)
    }
}
