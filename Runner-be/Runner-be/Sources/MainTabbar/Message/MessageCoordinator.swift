//
//  MessageCoordinator.swift
//  Runner-be
//
//  Created by 이유리 on 2022/04/26.
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

        scene.VM.routes.goMessageRoom
            .map { (vm: scene.VM, roomId: $0) }
            .subscribe(onNext: { [weak self] result in
                self?.pushMessageRoomScene(vm: result.vm, roomId: result.roomId, animated: true)
            })
            .disposed(by: sceneDisposeBag)
    }

    func pushMessageRoomScene(vm: MessageViewModel, roomId: Int, animated: Bool) {
        let comp = component.messageRoomComponent(roomId: roomId)
        let coord = MessageRoomCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case .backward:
                vm.routeInputs.needUpdate.onNext(true)
            case .report:
                break
            }
        }
    }
}
