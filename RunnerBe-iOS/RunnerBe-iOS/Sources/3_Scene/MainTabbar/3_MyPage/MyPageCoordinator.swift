//
//  3__3_MyPageCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import RxSwift

enum MyPageResult {
    case logout
    case toMain
}

final class MyPageCoordinator: TabCoordinator<MyPageResult> {
    // MARK: Lifecycle

    init(component: MyPageComponent, tabController: UITabBarController, navController: UINavigationController) {
        self.component = component
        super.init(tabController: tabController, navController: navController)
    }

    // MARK: Internal

    var component: MyPageComponent

    override func start(animated _: Bool = true) {
        let scene = component.sharedScene

        scene.VM.routes.editInfo
            .map { (vm: scene.VM, user: $0) }
            .subscribe(onNext: { [weak self] result in
                self?.pushEditInfoScene(vm: result.vm, user: result.user, animated: true)
            })
            .disposed(by: disposeBag)

        scene.VM.routes.detailPost
            .map { (vm: scene.VM, postId: $0) }
            .subscribe(onNext: { [weak self] result in
                self?.pushDetailPostScene(vm: result.vm, postId: result.postId, animated: true)
            })
            .disposed(by: disposeBag)

        scene.VM.routes.settings
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.pushSettingsScene(vm: vm, animated: true)
            })
            .disposed(by: disposeBag)

        scene.VM.routes.toMain
            .map { MyPageResult.toMain }
            .subscribe(closeSignal)
            .disposed(by: disposeBag)

        scene.VM.routes.writePost
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.pushWritingPostScene(vm: vm, animated: true)
            })
            .disposed(by: disposeBag)
    }

    func pushEditInfoScene(vm: MyPageViewModel, user: User, animated: Bool) {
        let comp = component.editInfoComponent(user: user)
        let coord = EditInfoCoordinator(component: comp, navController: navController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.release(coordinator: coord) }
                switch coordResult {
                case let .backward(needUpdate):
                    vm.routeInputs.needUpdate.onNext(needUpdate)
                }
            })

        addChildBag(id: coord.id, disposable: disposable)
    }

    func pushDetailPostScene(vm: MyPageViewModel, postId: Int, animated: Bool) {
        let comp = component.postDetailComponent(postId: postId)
        let coord = PostDetailCoordinator(component: comp, navController: navController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.release(coordinator: coord) }
                switch coordResult {
                case let .backward(id, marked, needUpdate):
                    vm.routeInputs.needUpdate.onNext(needUpdate)
                    vm.routeInputs.detailClosed.onNext((id: id, marked: marked))
                }
            })

        addChildBag(id: coord.id, disposable: disposable)
    }

    func pushSettingsScene(vm _: MyPageViewModel, animated: Bool) {
        let comp = component.settingsComponent
        let coord = SettingsCoordinator(component: comp, navController: navController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.release(coordinator: coord) }
                switch coordResult {
                case .backward:
                    break
                case .logout:
                    self?.closeSignal.onNext(MyPageResult.logout)
                }
            })

        addChildBag(id: coord.id, disposable: disposable)
    }

    private func pushWritingPostScene(vm: MyPageViewModel, animated: Bool) {
        let comp = component.writingPostComponent
        let coord = WritingMainPostCoordinator(component: comp, navController: navController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.release(coordinator: coord) }
                switch coordResult {
                case let .backward(needUpdate):
                    vm.routeInputs.needUpdate.onNext(needUpdate)
                }
            })

        addChildBag(id: coord.id, disposable: disposable)
    }
}
