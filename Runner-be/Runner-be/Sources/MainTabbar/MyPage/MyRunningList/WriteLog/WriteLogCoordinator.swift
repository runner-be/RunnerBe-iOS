//
//  WriteLogCoordinator.swift
//  Runner-be
//
//  Created by 김창규 on 8/30/24.
//

import UIKit

enum WriteLogResult {
    case backward(Bool)
}

final class WriteLogCoordinator: BasicCoordinator<WriteLogResult> {
    var component: WriteLogComponent

    init(
        component: WriteLogComponent,
        navController: UINavigationController
    ) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated: Bool) {
        let scene = component.scene
        navigationController.pushViewController(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController.popViewController(animated: animated)
            }).disposed(by: sceneDisposeBag)

        scene.VM.routes.backward
            .map { WriteLogResult.backward($0) }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.logStampBottomSheet
            .map { (vm: scene.VM, result: $0) }
            .bind { [weak self] inputs in
                let selectedLogStamp = inputs.result
                let title = inputs.result.title
                self?.pushLogStampBottomSheetScene(
                    vm: inputs.vm,
                    selectedLogStamp: selectedLogStamp,
                    title: title,
                    animated: false
                )
            }.disposed(by: sceneDisposeBag)

        scene.VM.routes.stampBottomSheet
            .map { (vm: scene.VM, selectedStamp: $0.stamp, selectedTemp: $0.temp) }
            .bind { [weak self] inputs in
                self?.pushStampBottomSheetScene(
                    vm: inputs.vm,
                    selectedStamp: inputs.selectedStamp,
                    selectedTemp: inputs.selectedTemp,
                    animated: false
                )
            }.disposed(by: sceneDisposeBag)

        scene.VM.routes.photoModal
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.presentPhotoModal(vm: vm, animated: false)
            }).disposed(by: sceneDisposeBag)

        scene.VM.routes.togetherRunner
            .map { scene.VM }
            .bind { [weak self] vm in
                self?.pushTogetherRunnerScene(vm: vm, animated: true)
            }.disposed(by: sceneDisposeBag)

        scene.VM.routes.backwardModal
            .map { scene.VM }
            .bind { [weak self] vm in
                self?.showLogModalScene(
                    vm: vm,
                    animated: false
                )
            }.disposed(by: sceneDisposeBag)
    }

    private func pushLogStampBottomSheetScene(
        vm: WriteLogViewModel,
        selectedLogStamp: StampType,
        title: String,
        animated: Bool
    ) {
        let comp = component.logStampBottomSheetComponent(
            selectedLogStamp: selectedLogStamp,
            title: title
        )
        let coord = LogStampBottomSheetCoordinator(
            component: comp,
            navController: navigationController
        )

        coordinate(
            coordinator: coord,
            animated: animated
        ) { coordResult in
            switch coordResult {
            case .backward:
                break
            case let .apply(logStamp):
                vm.routeInputs.selectedLogStamp.onNext(logStamp)
            }
        }
    }

    private func pushStampBottomSheetScene(
        vm: WriteLogViewModel,
        selectedStamp: StampType,
        selectedTemp: String,
        animated: Bool
    ) {
        let comp = component.stampBottomSheetComponent(
            selectedStamp: selectedStamp,
            selectedTemp: selectedTemp
        )
        let coord = StampBottomSheetCoordinator(
            component: comp,
            navController: navigationController
        )

        coordinate(
            coordinator: coord,
            animated: animated
        ) { coordResult in
            switch coordResult {
            case .backward:
                break
            case let .apply(selectedStamp, selectedTemp):
                vm.routeInputs.selectedWeather.onNext((
                    stamp: selectedStamp,
                    temp: selectedTemp
                ))
            }
        }
    }

    private func presentPhotoModal(vm: WriteLogViewModel, animated: Bool) {
        let comp = component.takePhotoModalComponent
        let coord = TakePhotoModalCoordinator(component: comp, navController: navigationController)
        let uuid = coord.identifier

        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case .takePhoto:
                vm.routeInputs.photoTypeSelected.onNext(.camera)
            case .choosePhoto:
                vm.routeInputs.photoTypeSelected.onNext(.library)
            case .cancel:
                break
            case .chooseDefault:
                break
            }
        }
    }

    private func pushTogetherRunnerScene(
        vm _: WriteLogViewModel,
        animated: Bool
    ) {
        let comp = component.togetherRunnerComponent
        let coord = TogetherRunnerCoordinator(
            component: comp,
            navController: navigationController
        )

        coordinate(
            coordinator: coord,
            animated: animated
        ) { coordResult in
            switch coordResult {
            case .backward:
                break
            }
        }
    }

    private func showLogModalScene(
        vm: WriteLogViewModel,
        animated: Bool
    ) {
        let comp = component.logModalComponent
        let coord = LogModalCoordinator(
            component: comp,
            navController: navigationController
        )

        coordinate(
            coordinator: coord,
            animated: animated
        ) { coordResult in
            switch coordResult {
            case .agree:
                vm.routes.backward.onNext(true)
            case .backward:
                break
            }
        }
    }
}
