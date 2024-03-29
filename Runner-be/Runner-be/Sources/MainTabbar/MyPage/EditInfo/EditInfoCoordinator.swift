//
//  EditInfoCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import Foundation
import RxSwift

enum EditInfoResult {
    case backward(needUpdate: Bool)
}

final class EditInfoCoordinator: BasicCoordinator<EditInfoResult> {
    var component: EditInfoComponent

    init(component: EditInfoComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated _: Bool) {
        let scene = component.scene
        navigationController.pushViewController(scene.VC, animated: true)

        closeSignal
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController.popViewController(animated: true)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.backward
            .map { EditInfoResult.backward(needUpdate: $0) }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.nickNameModal
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.presentNickNameModal(vm: vm, animated: false)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.jobModal
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.presentJobModal(vm: vm, animated: false)
            })
            .disposed(by: sceneDisposeBag)
    }

    private func presentNickNameModal(vm: EditInfoViewModel, animated: Bool) {
        let comp = component.nickNameModalComponent
        let coord = NickNameChangeModalCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case .ok:
                vm.routeInputs.changeNickName.onNext(true)
            case .cancel:
                vm.routeInputs.changeNickName.onNext(false)
            }
        }
    }

    private func presentJobModal(vm: EditInfoViewModel, animated: Bool) {
        let comp = component.jobChangeModalComponent
        let coord = JobChangeModalCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case .ok:
                vm.routeInputs.changeJob.onNext(true)
            case .cancel:
                vm.routeInputs.changeJob.onNext(false)
            }
        }
    }
}
