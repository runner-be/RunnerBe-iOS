//
//  3__3_MyPageCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import RxSwift

enum MyPageResult { // mypage에서 발생할 수 있는 모든 result를 enum으로 모아둠
    case logout
    case toMain
}

final class MyPageCoordinator: BasicCoordinator<MyPageResult> {
    // MARK: Lifecycle

    init(component: MyPageComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: MyPageComponent

    override func start(animated _: Bool = true) {
        let scene = component.scene

        scene.VM.routes.editInfo
            .map { (vm: scene.VM, user: $0) }
            .subscribe(onNext: { [weak self] result in
                self?.pushEditInfoScene(vm: result.vm, user: result.user, animated: true)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.detailPost
            .map { (vm: scene.VM, postId: $0) }
            .subscribe(onNext: { [weak self] result in
                self?.pushDetailPostScene(vm: result.vm, postId: result.postId, animated: true)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.settings // 설정으로 화면전환
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.pushSettingsScene(vm: vm, animated: true)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.toMain
            .map { MyPageResult.toMain }
            .subscribe(closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.writePost
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.pushWritingPostScene(vm: vm, animated: true)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.photoModal
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.presentPhotoModal(vm: vm, animated: false)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.manageAttendance
            .map { (vm: scene.VM, myRunningIdx: $0) }
            .subscribe(onNext: { [weak self] result in
                self?.pushManageAttendanceScene(vm: result.vm, myRunningIdx: result.myRunningIdx, animated: true)
            })
            .disposed(by: sceneDisposeBag)
    }

    func pushEditInfoScene(vm: MyPageViewModel, user: User, animated: Bool) {
        let comp = component.editInfoComponent(user: user)
        let coord = EditInfoCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case let .backward(needUpdate):
                vm.routeInputs.needUpdate.onNext(needUpdate)
            }
        }
    }

    func pushDetailPostScene(vm: MyPageViewModel, postId: Int, animated: Bool) {
        let comp = component.postDetailComponent(postId: postId)
        let coord = PostDetailCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case let .backward(id, needUpdate):
                vm.routeInputs.needUpdate.onNext(needUpdate)
                vm.routeInputs.detailClosed.onNext(())
            }
        }
    }

    func pushSettingsScene(vm _: MyPageViewModel, animated: Bool) {
        let comp = component.settingsComponent
        let coord = SettingsCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: animated) { [weak self] coordResult in
            switch coordResult {
            case .backward:
                break
            case .logout:
                self?.closeSignal.onNext(MyPageResult.logout)
            }
        }
    }

    private func pushWritingPostScene(vm: MyPageViewModel, animated: Bool) {
        let comp = component.writingPostComponent
        let coord = WritingMainPostCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case let .backward(needUpdate):
                vm.routeInputs.needUpdate.onNext(needUpdate)
            }
        }
    }

    private func presentPhotoModal(vm: MyPageViewModel, animated: Bool) {
        let comp = component.takePhotoModalComponent
        let coord = TakePhotoModalCoordinator(component: comp, navController: navigationController)
        let uuid = coord.identifier

        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case .takePhoto:
                vm.routeInputs.photoTypeSelected.onNext(.camera)
            case .choosePhoto:
                vm.routeInputs.photoTypeSelected.onNext(.library)
            case .cancel:
                break
            case .chooseDefault:
                vm.routeInputs.photoTypeSelected.onNext(.basic)
            }
        }
    }

    func pushManageAttendanceScene(vm _: MyPageViewModel, myRunningIdx: Int, animated: Bool) {
        let comp = component.manageAttendanceComponent(myRunningIdx: myRunningIdx)
        let coord = ManageAttendanceCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case .backward:
                break
            }
        }
    }
}
