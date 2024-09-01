//
//  LogStampBottomSheetCoordinator.swift
//  Runner-be
//
//  Created by 김창규 on 9/1/24.
//

import UIKit

enum LogStampBottomSheetResult {
    case backward
    case apply(LogStamp2)
}

final class LogStampBottomSheetCoordinator: BasicCoordinator<LogStampBottomSheetResult> {
    var component: LogStampBottomSheetComponent

    init(
        component: LogStampBottomSheetComponent,
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
                case let .apply(logStamp):
                    scene.VC.dismiss(animated: animated)
                }

            }).disposed(by: sceneDisposeBag)

        scene.VM.routes.backward
            .map { LogStampBottomSheetResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.applay
            .map { LogStampBottomSheetResult.apply($0) }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}
