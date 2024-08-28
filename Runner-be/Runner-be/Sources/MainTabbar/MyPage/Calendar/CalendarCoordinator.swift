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
            .map { (vm: scene.VM, year: $0.year, month: $0.month) }
            .subscribe(onNext: { [weak self] input in
                self?.showDateBottomSheet(
                    vm: input.vm,
                    year: input.year,
                    month: input.month,
                    animated: false
                )
            }).disposed(by: sceneDisposeBag)
    }

    private func showDateBottomSheet(
        vm: CalendarViewModel,
        year: Int,
        month: Int,
        animated: Bool
    ) {
        let comp = component.selectDateComponent(year: year, month: month)
        let coord = SelectDateBottomSheetCoordinator(
            component: comp,
            navController: navigationController
        )

        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case let .apply(year, month):
                vm.routeInputs.needUpdate.onNext((year, month, true))
            case .cancel:
                break
            }
        }
    }
}
