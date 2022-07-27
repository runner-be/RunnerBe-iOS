//
//  3__0_HomeCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import RxSwift
import UIKit

enum HomeResult {
    case needCover
}

final class HomeCoordinator: BasicCoordinator<HomeResult> {
    // MARK: Lifecycle

    init(component: HomeComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: HomeComponent

    override func start(animated _: Bool = true) {
        let scene = component.scene

        scene.VM.routes.filter
            .map { (vm: scene.VM, filter: $0) }
            .subscribe(onNext: { [weak self] input in
                self?.pushHomeFilterScene(vm: input.vm, filter: input.filter, animated: true)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.writingPost
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.pushWritingPostScene(vm: vm, animated: true)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.detailPost
            .map { (vm: scene.VM, postId: $0) }
            .subscribe(onNext: { [weak self] input in
                self?.pushDetailPostScene(vm: input.vm, postId: input.postId, animated: true)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.nonMemberCover
            .map { .needCover }
            .subscribe(closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.postListOrder
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.showPostListOrderModal(vm: vm, animated: false)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.runningTag
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.showRunningTagModal(vm: vm, animated: false)
            })
            .disposed(by: sceneDisposeBag)
    }

    private func pushDetailPostScene(vm: HomeViewModel, postId: Int, animated: Bool) {
        let comp = component.postDetailComponent(postId: postId)
        let coord = PostDetailCoordinator(component: comp, navController: navigationController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.releaseChild(coordinator: coord) }
                switch coordResult {
                case let .backward(id, marked, needUpdate):
                    vm.routeInputs.needUpdate.onNext(needUpdate)
                    vm.routeInputs.detailClosed.onNext((id: id, marked: marked))
                }
            })

        addChildDisposable(id: coord.identifier, disposable: disposable)
    }

    private func pushWritingPostScene(vm: HomeViewModel, animated: Bool) {
        let comp = component.writingPostComponent
        let coord = WritingMainPostCoordinator(component: comp, navController: navigationController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.releaseChild(coordinator: coord) }
                switch coordResult {
                case let .backward(needUpdate):
                    vm.routeInputs.needUpdate.onNext(needUpdate)
                }
            })

        addChildDisposable(id: coord.identifier, disposable: disposable)
    }

    private func pushHomeFilterScene(vm: HomeViewModel, filter: PostFilter, animated: Bool) {
        let comp = component.postFilterComponent(filter: filter)
        let coord = HomeFilterCoordinator(component: comp, navController: navigationController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.releaseChild(coordinator: coord) }
                switch coordResult {
                case let .backward(filter):
                    vm.routeInputs.filterChanged.onNext(filter)
                }
            })

        addChildDisposable(id: coord.identifier, disposable: disposable)
    }

    private func showPostListOrderModal(vm: HomeViewModel, animated: Bool) {
        let comp = component.postListOrderModal()
        let coord = PostOrderModalCoordinator(component: comp, navController: navigationController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.releaseChild(coordinator: coord) }
                switch coordResult {
                case let .ok(order: order):
                    vm.routeInputs.postListOrderChanged.onNext(order)
                case .cancel: break
                }
            })

        addChildDisposable(id: coord.identifier, disposable: disposable)
    }

    private func showRunningTagModal(vm: HomeViewModel, animated: Bool) {
        let comp = component.runningTagModal()
        let coord = RunningTagModalCoordinator(component: comp, navController: navigationController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.releaseChild(coordinator: coord) }
                switch coordResult {
                case let .ok(tag: tag):
                    vm.routeInputs.runningTagChanged.onNext(tag)
                case .cancel: break
                }
            })

        addChildDisposable(id: coord.identifier, disposable: disposable)
    }
}
