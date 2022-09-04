//
//  MessageReportCoordinator.swift
//  Runner-be
//
//  Created by 이유리 on 2022/08/13.
//

import Foundation
import RxSwift

enum MessageReportResult {
    case backward(needUpdate: Bool)
    case reportModal
}

final class MessageReportCoordinator: BasicCoordinator<MessageReportResult> {
    var component: MessageReportComponent

    init(component: MessageReportComponent, navController: UINavigationController) {
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
            .map { MessageReportResult.backward(needUpdate: $0) }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.report
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.presentReportModal(vm: vm, animated: false)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.detailPost
            .map { (vm: scene.VM, postId: $0) }
            .subscribe(onNext: { [weak self] result in
                self?.pushDetailPostScene(vm: result.vm, postId: result.postId, animated: true)
            })
            .disposed(by: sceneDisposeBag)
    }

    private func presentReportModal(vm: MessageReportViewModel, animated: Bool) {
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

    func pushDetailPostScene(vm: MessageReportViewModel, postId: Int, animated: Bool) {
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
