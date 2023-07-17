//
//  MessageCoordinator.swift
//  Runner-be
//
//  Created by 김신우 on 2022/04/26.
//

import Foundation
import RxSwift

enum MessageRoomResult {
    case backward(needUpdate: Bool)
    case report
}

final class MessageRoomCoordinator: BasicCoordinator<MessageRoomResult> {
    var component: MessageRoomComponent

    init(component: MessageRoomComponent, navController: UINavigationController) {
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
            .map { MessageRoomResult.backward(needUpdate: $0) }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.report
            .map { (vm: scene.VM, roomId: $0) }
            .subscribe(onNext: { [weak self] result in
                self?.pushMessageReportScene(vm: result.vm, roomId: result.roomId)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.detailPost
            .map { (vm: scene.VM, postId: $0) }
            .subscribe(onNext: { [weak self] result in
                if self?.component.fromPostDetail == true {
                    self?.closeSignal.onNext(MessageRoomResult.backward(needUpdate: false))
                } else {
                    self?.pushDetailPostScene(vm: result.vm, postId: result.postId)
                }
            })
            .disposed(by: sceneDisposeBag)
    }

    func pushMessageReportScene(vm: MessageRoomViewModel, roomId: Int) {
        let comp = component.reportMessageComponent(roomId: roomId)
        let coord = MessageReportCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord) { coordResult in
            switch coordResult {
            case let .backward(needUpdate):
                vm.routeInputs.needUpdate.onNext(needUpdate)
            case .reportModal:
                vm.routeInputs.report.onNext(roomId)
            }
        }
    }

    func pushDetailPostScene(vm: MessageRoomViewModel, postId: Int) {
        let comp = component.postDetailComponent(postId: postId)
        let coord = PostDetailCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord) { [weak self] coordResult in
            switch coordResult {
            case let .backward(_, needUpdate):
                vm.routeInputs.needUpdate.onNext(needUpdate)
            }
        }
    }
}
