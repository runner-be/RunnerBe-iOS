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
                Log.d(tag: .lifeCycle, "VC poped")
                switch result {
                case .backward:
                    self?.navigationController.popViewController(animated: true)
                }
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.backward
            .debug()
            .map { WritingMainPostResult.backward(needUpdate: false) }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.next
            .subscribe(onNext: { [weak self] in
                self?.pushWritingDetailPost(data: $0, animated: true)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.editTime
            .map { (vm: scene.VM, timeString: $0) }
            .subscribe(onNext: { [weak self] result in
                self?.presentSelectTimeModal(vm: result.vm, timeString: result.timeString, animated: false)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.editDate
            .map { (vm: scene.VM, dateInterval: $0) }
            .subscribe(onNext: { [weak self] result in
                self?.presentSelectDateModal(vm: result.vm, dateInterval: result.dateInterval, animated: false)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.editPlace
            .map { (vm: scene.VM, timeString: $0) }
            .subscribe(onNext: { [weak self] result in
                self?.pushSelectPlace(
                    vm: result.vm,
                    timeString: result.timeString,
                    animated: true
                )

            }).disposed(by: sceneDisposeBag)
    }

    private func pushWritingDetailPost(data: WritingPostData, animated: Bool) {
        let comp = component.BuildWritingDetailPostComponent(with: data)
        let coord = WritingDetailPostCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: animated) { [weak self] coordResult in
            switch coordResult {
            case .backward:
                break
            case .apply:
                self?.closeSignal.onNext(.backward(needUpdate: true))
            }
        }
    }

    private func pushSelectPlace(
        vm: WritingMainPostViewModel,
        timeString: String,
        animated: Bool
    ) {
        let comp = component.selectPlaceComponent(timeString: timeString)
        let coord = SelectPlaceCoordinator(
            component: comp,
            navController: navigationController
        )

        coordinate(
            coordinator: coord,
            animated: animated
        ) { coordResult in
            switch coordResult {
            case let .apply(resultString):
                vm.routeInputs.editPlaceResult.onNext(resultString)
            case .cancel:
                break
            }
        }
    }

    private func presentSelectTimeModal(vm: WritingMainPostViewModel, timeString: String, animated: Bool) {
        let comp = component.selectTimeComponent(timeString: timeString)
        let coord = SelectTimeModalCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case let .apply(resultString):
                vm.routeInputs.editTimeResult.onNext(resultString)
            case .cancel:
                break
            }
        }
    }

    private func presentSelectDateModal(vm: WritingMainPostViewModel, dateInterval: Double, animated: Bool) {
        let comp = component.selectDateComponent(dateInterval: dateInterval)
        let coord = SelectDateModalCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case let .apply(timeInterval):
                vm.routeInputs.editDateResult.onNext(timeInterval)
            case .cancel:
                break
            }
        }
    }
}
