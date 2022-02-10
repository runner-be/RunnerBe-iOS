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
        let viewController = component.photoModalViewController

        viewController.modalPresentationStyle = .overCurrentContext
        navController.present(viewController, animated: false)

        closeSignal
            .subscribe(onNext: { _ in
                viewController.dismiss(animated: false)
            })
            .disposed(by: disposeBag)

        component.photoModalViewModel.routes.backward
            .map { PhotoModalResult.cancel }
            .subscribe(closeSignal)
            .disposed(by: disposeBag)

        component.photoModalViewModel.routes.choosePhoto
            .map { PhotoModalResult.choosePhoto }
            .subscribe(closeSignal)
            .disposed(by: disposeBag)

        component.photoModalViewModel.routes.takePhoto
            .map { PhotoModalResult.takePhoto }
            .subscribe(closeSignal)
            .disposed(by: disposeBag)
    }
}
