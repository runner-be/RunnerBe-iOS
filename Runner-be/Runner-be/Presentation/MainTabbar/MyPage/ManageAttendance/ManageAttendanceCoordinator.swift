//
//  ManageAttendanceCordinator.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/04.
//

import Foundation
import RxSwift

enum ManageAttendanceResult {
    case backward
}

final class ManageAttendanceCoordinator: BasicCoordinator<ManageAttendanceResult> {
    var component: ManageAttendanceComponent

    init(component: ManageAttendanceComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated _: Bool = true) {
        let scene = component.scene
        navigationController.pushViewController(scene.VC, animated: true)

        closeSignal
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .backward:
                    self?.navigationController.popViewController(animated: true)
                }
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.backward
            .map { ManageAttendanceResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.showExpiredModal
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.presentExpiredModal(vm: vm, animated: false)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.goToMyPage
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.configureAndGetMyPageScene(vm: vm)
            })
            .disposed(by: sceneDisposeBag)
    }

    private func presentExpiredModal(vm: ManageAttendanceViewModel, animated: Bool) {
        let comp = component.manageExpiredModalComponent
        let coord = ManageTimeExpiredModalCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case .ok:
                vm.routes.goToMyPage.onNext(())
            }
        }
    }

    private func configureAndGetMyPageScene(vm: ManageAttendanceViewModel) {
        let comp = component.myPageComponent
        let coord = MyPageCoordinator(component: comp, navController: navigationController)

        vm.routes.backward.onNext(()) // 출석관리하기 화면 종료

        coordinate(coordinator: coord, animated: false, needRelease: false)
        // 마이페이지 이동

        comp.scene.VM.routeInputs.needUpdate.onNext(true)
    }
}
