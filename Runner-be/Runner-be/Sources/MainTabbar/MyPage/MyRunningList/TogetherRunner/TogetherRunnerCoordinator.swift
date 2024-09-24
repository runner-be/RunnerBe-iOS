//
//  TogetherRunnerCoordinator.swift
//  Runner-be
//
//  Created by 김창규 on 9/3/24.
//

import UIKit

enum TogetherRunnerResult {
    case backward
}

final class TogetherRunnerCoordinator: BasicCoordinator<TogetherRunnerResult> {
    var component: TogetherRunnerComponent

    init(
        component: TogetherRunnerComponent,
        navController: UINavigationController
    ) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated: Bool = true) {
        let scene = component.scene
        navigationController.pushViewController(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .backward:
                    self?.navigationController.popViewController(animated: animated)
                }

            }).disposed(by: sceneDisposeBag)

        scene.VM.routes.backward
            .map { TogetherRunnerResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.logStampBottomSheet
            .map { (vm: scene.VM, result: $0) }
            .bind { [weak self] inputs in
                self?.pushLogStampBottomSheetScene(
                    vm: inputs.vm,
                    selectedLogStamp: inputs.result.stamp,
                    title: inputs.result.title,
                    animated: false
                )
            }.disposed(by: sceneDisposeBag)

        scene.VM.routes.confirmLog
            .map { (vm: scene.VM, logForm: $0) }
            .bind { [weak self] inputs in
                self?.pushConfirmLogScene(
                    vm: inputs.vm,
                    logForm: inputs.logForm,
                    animated: true
                )
            }.disposed(by: sceneDisposeBag)
    }

    private func pushLogStampBottomSheetScene(
        vm: TogetherRunnerViewModel,
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
                vm.routeInputs.needUpdate.onNext(true)
            case let .apply(stampType):
                vm.routeInputs.selectedLogStamp.onNext(stampType)
            }
        }
    }

    private func pushConfirmLogScene(
        vm _: TogetherRunnerViewModel,
        logForm: LogForm,
        animated: Bool
    ) {
        let comp = component.confirmLogComponent(logForm: logForm)
        let coord = ConfirmLogCoordinator(
            component: comp,
            navController: navigationController
        )

        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case .backward:
                break
            }
        }
    }
}
