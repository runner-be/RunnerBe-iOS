//
//  WritingMainPostCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/18.
//

import Foundation
import RxSwift

enum WritingMainPostResult {
    case backward(needUpdate: Bool)
}

final class WritingMainPostCoordinator: BasicCoordinator<WritingMainPostResult> {
    var component: WritingMainPostComponent

    init(component: WritingMainPostComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated: Bool) {
        let scene = component.scene
        navigationController.pushViewController(scene.VC, animated: animated)

        closeSignal
            .debug()
            .subscribe(onNext: { [weak self] result in
                #if DEBUG
                    print("[WritingMainPostCoordinator][closeSignal] popViewController")
                #endif
                switch result {
                case .backward:
                    self?.navigationController.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)

        scene.VM.routes.backward
            .debug()
            .map { WritingMainPostResult.backward(needUpdate: false) }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)

        scene.VM.routes.next
            .subscribe(onNext: { [weak self] in
                self?.pushWritingDetailPost(data: $0, animated: true)
            })
            .disposed(by: disposeBag)

        scene.VM.routes.editTime
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.presentSelectTimeModal(vm: vm, animated: false)
            })
            .disposed(by: disposeBag)

        scene.VM.routes.editDate
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.presentSelectDateModal(vm: vm, animated: false)
            })
            .disposed(by: disposeBag)
    }

    private func pushWritingDetailPost(data: WritingPostDetailConfigData, animated _: Bool) {
        let comp = component.BuildWritingDetailPostComponent(with: data)
        let coord = WritingDetailPostCoordinator(component: comp, navController: navigationController)

        let disposable = coordinate(coordinator: coord)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.releaseChild(coordinator: coord) }
                switch coordResult {
                case .backward:
                    break
                case .apply:
                    self?.closeSignal.onNext(.backward(needUpdate: true))
                }
            })

        addChildDisposable(id: coord.identifier, disposable: disposable)
    }

    private func presentSelectTimeModal(vm: WritingMainPostViewModel, animated: Bool) {
        let comp = component.selectTimeComponent
        let coord = SelectTimeModalCoordinator(component: comp, navController: navigationController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.releaseChild(coordinator: coord) }
                switch coordResult {
                case let .apply(resultString):
                    vm.routeInputs.editTimeResult.onNext(resultString)
                case .cancel:
                    break
                }
            })

        addChildDisposable(id: coord.identifier, disposable: disposable)
    }

    private func presentSelectDateModal(vm: WritingMainPostViewModel, animated: Bool) {
        let comp = component.selectDateComponent
        let coord = SelectDateModalCoordinator(component: comp, navController: navigationController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.releaseChild(coordinator: coord) }
                switch coordResult {
                case let .apply(resultString):
                    vm.routeInputs.editDateResult.onNext(resultString)
                case .cancel:
                    break
                }
            })

        addChildDisposable(id: coord.identifier, disposable: disposable)
    }
}
