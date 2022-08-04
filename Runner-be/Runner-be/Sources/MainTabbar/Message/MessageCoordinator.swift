//
//  MessageCoordinator.swift
//  Runner-be
//
//  Created by 김신우 on 2022/04/26.
//

import Foundation
import RxSwift

enum MessageResult {
    case messageChat
}

final class MessageCoordinator: BasicCoordinator<MessageResult> {
    var component: MessageComponent

    init(component: MessageComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated _: Bool) {
        let scene = component.scene

        closeSignal
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController.popViewController(animated: true)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.messageChat
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.pushMessageChatScene(vm: vm, animated: false)
            })
            .disposed(by: sceneDisposeBag)
    }

    func pushMessageChatScene(vm _: MessageViewModel, animated: Bool) {
        let comp = component.messageChatComponent
        let coord = MessageChatCoordinator(component: comp, navController: navigationController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.releaseChild(coordinator: coord) }
                switch coordResult {
                case .backward:
                    break
                case .report:
                    break
//                    vm.routes.
                }
            })

        addChildDisposable(id: coord.identifier, disposable: disposable)
    }
}
