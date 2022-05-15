//
//  MessageDeleteComponent.swift
//  Runner-be
//
//  Created by 이유리 on 2022/05/07.
//

import Foundation
import RxSwift

enum MessageDeleteResult {
    case backward
}

final class MessageDeleteCoordinator: BasicCoordinator<MessageDeleteResult> {
    var component: MessageDeleteComponent

    init(component: MessageDeleteComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated: Bool) {
        let scene = component.scene

        navigationController.pushViewController(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .backward:
                    self?.navigationController.popViewController(animated: true)
                }
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.backward
            .map { MessageDeleteResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}
