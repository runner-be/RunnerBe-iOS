//
//  PhotoModalCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/09.
//

import Foundation
import RxSwift

enum PhotoModalResult {
    case cancel
    case takePhoto
    case choosePhoto
}

final class PhotoModalCoordinator: BasicCoordinator<PhotoModalResult> {
    var component: PhotoModalComponent

    init(component: PhotoModalComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start() {
        let photoModalViewController = component.photoModalViewController

        photoModalViewController.modalPresentationStyle = .overCurrentContext
        navController.present(photoModalViewController, animated: false)

        component.photoModalViewModel.routes.backward
            .do(onNext: {
                photoModalViewController.dismiss(animated: false)
            })
            .map { PhotoModalResult.cancel }
            .subscribe(closeSignal)
            .disposed(by: disposeBag)

        component.photoModalViewModel.routes.choosePhoto
            .do(onNext: {
                photoModalViewController.dismiss(animated: false)
            })
            .map { PhotoModalResult.choosePhoto }
            .subscribe(closeSignal)
            .disposed(by: disposeBag)

        component.photoModalViewModel.routes.takePhoto
            .do(onNext: {
                photoModalViewController.dismiss(animated: false)
            })
            .map { PhotoModalResult.takePhoto }
            .subscribe(closeSignal)
            .disposed(by: disposeBag)
    }
}
