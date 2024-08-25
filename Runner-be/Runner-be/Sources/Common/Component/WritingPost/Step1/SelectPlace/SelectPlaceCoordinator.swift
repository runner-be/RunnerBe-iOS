//
//  SelectPlaceCoordinator.swift
//  Runner-be
//
//  Created by 김창규 on 8/20/24.
//

import Foundation
import RxSwift

enum SelectPlaceResult {
    case cancel
    case apply(PlaceInfo)
}

final class SelectPlaceCoordinator: BasicCoordinator<SelectPlaceResult> {
    var component: SelectPlaceComponent

    init(
        component: SelectPlaceComponent,
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

        scene.VM.routes.apply
            .map { resultPlaceInfo in
                SelectPlaceResult.apply(resultPlaceInfo)
            }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.cancel
            .map { SelectPlaceResult.cancel }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.detailSelectPlace
            .map { (vm: scene.VM, completerResult: $0) }
            .subscribe(onNext: { [weak self] result in
                self?.pushDetailSelectPlace(
                    vm: result.vm,
                    placeInfo: PlaceInfo(
                        title: result.completerResult.title,
                        subTitle: result.completerResult.subtitle
                    ),
                    animated: true
                )
            })
            .disposed(by: sceneDisposeBag)
    }

    private func pushDetailSelectPlace(
        vm: SelectPlaceViewModel,
        placeInfo: PlaceInfo,
        animated: Bool
    ) {
        let comp = component.detailSelectPlaceComponent(placeInfo: placeInfo)
        let coord = DetailSelectPlaceCoordinator(
            component: comp,
            navController: navigationController
        )

        coordinate(
            coordinator: coord,
            animated: animated
        ) { coordResult in
            switch coordResult {
            case let .apply(resultPlaceInfo):
                vm.routes.apply.onNext(resultPlaceInfo)
            case .cancel:
                break
            }
        }
    }
}
