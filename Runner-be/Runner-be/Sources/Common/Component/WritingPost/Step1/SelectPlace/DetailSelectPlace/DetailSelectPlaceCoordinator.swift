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
    case apply(PlaceInfo)
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
            .bind { [weak self] result in
                switch result {
                case let .apply(placeInfo):
                    self?.navigationController.popViewController(animated: true)
                case .cancel:
                    self?.navigationController.popViewController(animated: true)
                }
            }.disposed(by: sceneDisposeBag)

        scene.VM.routes.cancel
            .map { DetailSelectPlaceResult.cancel }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.apply
            .map { placeInfo in
                DetailSelectPlaceResult.apply(placeInfo)
            }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}
