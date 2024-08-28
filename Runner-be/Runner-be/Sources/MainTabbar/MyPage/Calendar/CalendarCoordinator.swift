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
            .map { scene.VM }
            .subscribe(onNext: { [weak self] _ in

            }).disposed(by: sceneDisposeBag)
    }

    private func showDateBottomSheet(vm _: CalendarViewModel, animated _: Bool) {}
}
