//
//  ConfirmLogCoordinator.swift
//  Runner-be
//
//  Created by 김창규 on 8/30/24.
//

import UIKit

enum ConfirmLogResult {
    case backward(Bool)
}

final class ConfirmLogCoordinator: BasicCoordinator<ConfirmLogResult> {
    var component: ConfirmLogComponent

    init(
        component: ConfirmLogComponent,
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
            .map { ConfirmLogResult.backward($0) }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.modal
            .bind { [weak self] _ in
                self?.showMenuModalScene(
                    vm: scene.VM,
                    animated: false
                )
            }.disposed(by: sceneDisposeBag)
    }

    private func showMenuModalScene(
        vm _: ConfirmLogViewModel,
        animated: Bool
    ) {
        let comp = component.menuModalComponent
        let coord = MenuModalCoordinator(
            component: comp,
            navController: navigationController
        )

        coordinate(
            coordinator: coord,
            animated: animated
        ) { coordResult in
            switch coordResult {
            case .edit:
                print("로그 작성화면(수정)으로 이동합니다.")
            case .delete:
                print("로그 삭제 후 성공하면 해당 구간이 호출됩니다.")
            case .backward:
                print("모달을 종료합니다.")
            }
        }
    }
}
