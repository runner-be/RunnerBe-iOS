//
//  MessageCoordinator.swift
//  Runner-be
//
//  Created by 김신우 on 2022/04/26.
//

import Foundation
import RxSwift

enum MessageResult {}

final class MessageCoordinator: BasicCoordinator<MessageResult> {
    var component: MessageComponent

    init(component: MessageComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated _: Bool) {
        let scene = component.scene
        
        
    }
    
    private func pushMessageDeleteScene(vm: MessageDeleteViewModel, postId: Int, animated: Bool) {
//        let comp = component.messageDeleteComponent
//        let coord = MessageDeleteCoordinator(component: comp, navController: navigationController)
//
//        let disposable = coordinate(coordinator: coord, animated: animated)
//            .subscribe(onNext: { [weak self] coordResult in
//                defer { self?.releaseChild(coordinator: coord) }
//                switch coordResult {
//                case let .backward(id, marked, needUpdate):
//                    vm.routeInputs.needUpdate.onNext(needUpdate)
//                    vm.routeInputs.detailClosed.onNext((id: id, marked: marked))
//                }
//            })
//
//        addChildDisposable(id: coord.identifier, disposable: disposable)
    }
}
