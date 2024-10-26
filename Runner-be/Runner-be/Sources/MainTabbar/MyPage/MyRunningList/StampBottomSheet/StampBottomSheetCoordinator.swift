//
//  StampBottomSheetCoordinator.swift
//  Runner-be
//
//  Created by 김창규 on 9/2/24.
//

import UIKit

enum StampBottomSheetResult {
    case backward
    case apply(stamp: StampType, temp: String)
}

final class StampBottomSheetCoordinator: BasicCoordinator<StampBottomSheetResult> {
    var component: StampBottomSheetComponent

    init(
        component: StampBottomSheetComponent,
        navController: UINavigationController
    ) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated: Bool = true) {
        let scene = component.scene
        scene.VC.modalPresentationStyle = .overCurrentContext
        navigationController.present(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { result in
                switch result {
                case .backward:
                    scene.VC.dismiss(animated: animated)
                case .apply:
                    scene.VC.dismiss(animated: animated)
                }

            }).disposed(by: sceneDisposeBag)

        scene.VM.routes.backward
            .map { StampBottomSheetResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.apply
            .map { StampBottomSheetResult.apply(
                stamp: $0.stamp,
                temp: $0.temp
            ) }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}
