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
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.presentReportModal(vm: vm, animated: false)
            })
            .disposed(by: sceneDisposeBag)
    }

    private func presentReportModal(vm: MessageChatViewModel, animated: Bool) {
        let comp = component.reportModalComponent
        let coord = ReportModalCoordinator(component: comp, navController: navigationController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.releaseChild(coordinator: coord) }
                switch coordResult {
                case .ok:
                    vm.routeInputs.report.onNext(true)
                case .cancel:
                    vm.routeInputs.report.onNext(false)
                }
            })

        addChildDisposable(id: coord.identifier, disposable: disposable)
    }
}
