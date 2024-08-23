//
//  DetailSelectPlaceCoordinator.swift
//  Runner-be
//
//  Created by 김창규 on 8/23/24.
//

import Foundation
import RxSwift

enum DetailSelectPlaceResult {
    case cancel
    case apply(String)
}

final class DetailSelectPlaceCoordinator: BasicCoordinator<DetailSelectPlaceResult> {
    var component: DetailSelectPlaceComponent

    init(
        component: DetailSelectPlaceComponent,
        navController: UINavigationController
    ) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated: Bool = true) {
        let scene = component.scene
        navigationController.pushViewController(scene.VC, animated: animated)

        closeSignal
            .bind { [weak self] _ in
                self?.navigationController.popViewController(animated: true)
            }.disposed(by: sceneDisposeBag)

        scene.VM.routes.cancel
            .map { DetailSelectPlaceResult.cancel }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}
