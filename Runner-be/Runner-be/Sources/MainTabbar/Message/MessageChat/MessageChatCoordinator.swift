//
//  MessageCoordinator.swift
//  Runner-be
//
//  Created by 김신우 on 2022/04/26.
//

import Foundation
import RxSwift

enum MessageChatResult {
    case backward(needUpdate: Bool)
    case report
}

final class MessageChatCoordinator: BasicCoordinator<MessageChatResult> {
    var component: MessageChatComponent

    init(component: MessageChatComponent, navController: UINavigationController) {
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
            .map { MessageChatResult.backward(needUpdate: $0) }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.report
            .map { (vm: scene.VM, messageId: $0) }
            .subscribe(onNext: { [weak self] result in
                self?.pushMessageReportScene(vm: result.vm, messageId: result.messageId, animated: true)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.detailPost
            .map { (vm: scene.VM, postId: $0) }
            .subscribe(onNext: { [weak self] result in
                self?.pushDetailPostScene(vm: result.vm, postId: result.postId, animated: true)
            })
            .disposed(by: sceneDisposeBag)
    }

    func pushMessageReportScene(vm: MessageChatViewModel, messageId: Int, animated: Bool) {
        let comp = component.reportMessageComponent(messageId: messageId)
        let coord = MessageReportCoordinator(component: comp, navController: navigationController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.releaseChild(coordinator: coord) }
                switch coordResult {
                case let .backward(needUpdate):
                    vm.routeInputs.needUpdate.onNext(needUpdate)
                case .reportModal:
                    vm.routeInputs.report.onNext(messageId)
                }
            })

        addChildDisposable(id: coord.identifier, disposable: disposable)
    }

    func pushDetailPostScene(vm: MessageChatViewModel, postId: Int, animated: Bool) {
        let comp = component.postDetailComponent(postId: postId)
        let coord = PostDetailCoordinator(component: comp, navController: navigationController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.releaseChild(coordinator: coord) }
                switch coordResult {
                case let .backward(id, needUpdate):
                    vm.routeInputs.needUpdate.onNext(needUpdate)
                    vm.routeInputs.detailClosed.onNext(())
                }
            })

        addChildDisposable(id: coord.identifier, disposable: disposable)
    }
}