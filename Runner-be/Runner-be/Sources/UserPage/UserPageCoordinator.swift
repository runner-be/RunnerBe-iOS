//
//  UserPageCoordinator.swift
//  Runner-be
//
//  Created by 김창규 on 10/14/24.
//

import UIKit

enum UserPageResult {
    case backward
}

final class UserPageCoordinator: BasicCoordinator<UserPageResult> {
    var component: UserPageComponent

    init(
        component: UserPageComponent,
        navController: UINavigationController
    ) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated: Bool = true) {
        let scene = component.scene
        navigationController.pushViewController(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .backward:
                    self?.navigationController.popViewController(animated: animated)
                }

            }).disposed(by: sceneDisposeBag)

        scene.VM.routes.backward
            .map { UserPageResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.calendar
            .subscribe(onNext: { [weak self] userId in
                self?.pushCalendarScene(
                    userId: userId,
                    vm: scene.VM,
                    animated: true
                )
            }).disposed(by: sceneDisposeBag)

        scene.VM.routes.confirmLog
            .map { (vm: scene.VM, logId: $0) }
            .subscribe(onNext: { [weak self] inputs in
                self?.pushConfirmLog(
                    vm: inputs.vm,
                    logId: inputs.logId,
                    animated: true
                )
            }).disposed(by: sceneDisposeBag)

        scene.VM.routes.myRunningList
            .subscribe(onNext: { [weak self] userId in
                self?.pushUserRunningListScene(
                    userId: userId,
                    vm: scene.VM,
                    animated: true
                )
            }).disposed(by: sceneDisposeBag)

        scene.VM.routes.detailPost
            .map { (vm: scene.VM, postId: $0) }
            .subscribe(onNext: { [weak self] result in
                self?.pushDetailPostScene(vm: result.vm, postId: result.postId, animated: true)
            })
            .disposed(by: sceneDisposeBag)
    }

    private func pushCalendarScene(
        userId: Int,
        vm: UserPageViewModel,
        animated: Bool
    ) {
        let comp = component.calendarComponent(userId: userId)
        let coord = CalendarCoordinator(
            component: comp,
            navController: navigationController
        )

        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case .backward:
                vm.routeInputs.needUpdate.onNext(true)
            }
        }

        comp.viewModel.routeInputs.needUpdate.onNext((
            targetDate: nil,
            needUpdate: true
        ))
    }

    private func pushConfirmLog(
        vm: UserPageViewModel,
        logId: Int,
        animated: Bool
    ) {
        let comp = component.confirmLogComponent(logId: logId)
        let coord = ConfirmLogCoordinator(
            component: comp,
            navController: navigationController
        )

        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case let .backward(needUpdate):
                vm.routeInputs.needUpdate.onNext(false)
            }
        }
    }

    func pushUserRunningListScene(
        userId: Int,
        vm: UserPageViewModel,
        animated: Bool
    ) {
        let comp = component.userRunningListComponent(userId: userId)
        let coord = UserRunningListCoordinator(
            component: comp,
            navController: navigationController
        )

        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case .backward:
                vm.routeInputs.needUpdate.onNext(true)
            }
        }
        comp.scene.VM.routeInputs.needUpdate.onNext(true)
    }

    func pushDetailPostScene(vm: UserPageViewModel, postId: Int, animated: Bool) {
        let comp = component.postDetailComponent(postId: postId)
        let coord = PostDetailCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case let .backward(_, needUpdate):
                vm.routeInputs.needUpdate.onNext(needUpdate)
            }
        }
    }
}
