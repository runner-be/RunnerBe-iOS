//
//  CalendarCoordinator.swift
//  Runner-be
//
//  Created by 김창규 on 8/27/24.
//

import RxSwift

enum CalendarResult {
    case backward
}

final class CalendarCoordinator: BasicCoordinator<CalendarResult> {
    var component: CalendarComponent

    init(
        component: CalendarComponent,
        navController: UINavigationController
    ) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated _: Bool) {
        let scene = component.scene
        navigationController.pushViewController(scene.VC, animated: true)

        closeSignal
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .backward:
                    self?.navigationController.popViewController(animated: true)
                }
            }).disposed(by: sceneDisposeBag)

        scene.VM.routes.backward
            .map { CalendarResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.dateBottomSheet
            .map { (vm: scene.VM, selectedDate: $0) }
            .subscribe(onNext: { [weak self] input in
                self?.showDateBottomSheet(
                    vm: input.vm,
                    selectedDate: input.selectedDate,
                    animated: false
                )
            }).disposed(by: sceneDisposeBag)

        scene.VM.routes.confirmLog
            .map { (vm: scene.VM, logId: $0) }
            .subscribe(onNext: { [weak self] input in
                self?.pushConfirmLogScene(
                    vm: input.vm,
                    logId: input.logId,
                    animated: true
                )

            }).disposed(by: sceneDisposeBag)
    }

    private func showDateBottomSheet(
        vm: CalendarViewModel,
        selectedDate: Date,
        animated: Bool
    ) {
        let comp = component.selectDateComponent(selectedDate: selectedDate)
        let coord = SelectDateBottomSheetCoordinator(
            component: comp,
            navController: navigationController
        )

        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case let .apply(date):
                vm.routeInputs.needUpdate.onNext((date, true))
            case .cancel:
                break
            }
        }
    }

    private func pushConfirmLogScene(
        vm: CalendarViewModel,
        logId: Int,
        animated: Bool
    ) {
        let comp = component.confirmLogComponent(logId: logId)
        let coord = ConfirmLogCoordinator(
            component: comp,
            navController: navigationController
        )

        coordinate(
            coordinator: coord,
            animated: animated
        ) { coordResult in
            switch coordResult {
            case let .backward(needUpdate):
                vm.routeInputs.needUpdate.onNext((nil, needUpdate))
            }
        }
    }
}
