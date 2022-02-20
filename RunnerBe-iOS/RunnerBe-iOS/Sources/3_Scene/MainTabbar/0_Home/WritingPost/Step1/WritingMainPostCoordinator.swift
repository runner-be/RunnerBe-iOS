//
//  WritingMainPostCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/18.
//

import Foundation
import RxSwift

enum WritingMainPostResult {}

final class WritingMainPostCoordinator: BasicCoordinator<WritingMainPostResult> {
    var component: WritingMainPostComponent

    init(component: WritingMainPostComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated _: Bool) {
        let scene = component.scene
        navController.pushViewController(scene.VC, animated: true)

        closeSignal
            .subscribe(onNext: { [weak self] _ in
                #if DEBUG
                    print("[SelectJobCoordinator][closeSignal] popViewController")
                #endif

                self?.navController.popViewController(animated: true)
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

    private func presentSelectTimeModal(vm: WritingMainPostViewModel, animated: Bool) {
        let comp = component.selectTimeComponent
        let coord = SelectTimeModalCoordinator(component: comp, navController: navController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.release(coordinator: coord) }
                switch coordResult {
                case let .apply(resultString):
                    vm.routeInputs.editTimeResult.onNext(resultString)
                case .cancel:
                    break
                }
            })

        addChildBag(id: coord.id, disposable: disposable)
    }

    private func presentSelectDateModal(vm: WritingMainPostViewModel, animated: Bool) {
        let comp = component.selectDateComponent
        let coord = SelectDateModalCoordinator(component: comp, navController: navController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.release(coordinator: coord) }
                switch coordResult {
                case let .apply(resultString):
                    vm.routeInputs.editDateResult.onNext(resultString)
                case .cancel:
                    break
                }
            })

        addChildBag(id: coord.id, disposable: disposable)
    }
}
