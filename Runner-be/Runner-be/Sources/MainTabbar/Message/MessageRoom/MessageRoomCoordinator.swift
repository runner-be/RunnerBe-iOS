//
//  MessageRoomCoordinator.swift
//  Runner-be
//
//  Created by 김신우 on 2022/04/26.
//

import Foundation
import RxSwift

enum MessageRoomResult {
    case backward(needUpdate: Bool)
    case report
}

final class MessageRoomCoordinator: BasicCoordinator<MessageRoomResult> {
    var component: MessageRoomComponent

    init(component: MessageRoomComponent, navController: UINavigationController) {
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
            .map { MessageRoomResult.backward(needUpdate: $0) }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.report
            .map { (vm: scene.VM, roomId: $0) }
            .subscribe(onNext: { [weak self] result in
                self?.pushMessageReportScene(vm: result.vm, roomId: result.roomId)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.detailPost
            .map { (vm: scene.VM, postId: $0) }
            .subscribe(onNext: { [weak self] result in
                if self?.component.fromPostDetail == true {
                    self?.closeSignal.onNext(MessageRoomResult.backward(needUpdate: false))
                } else {
                    self?.pushDetailPostScene(vm: result.vm, postId: result.postId)
                }
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.photoModal
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.presentPhotoModal(vm: vm, animated: false)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.imageViewer
            .map { (vm: scene.VM, image: $0) }
            .subscribe(onNext: { [weak self] result in
                self?.presentImageViewer(
                    vm: result.vm,
                    image: result.image
                )
            }).disposed(by: sceneDisposeBag)

        scene.VM.routes.userPage
            .bind { [weak self] userId in
                self?.pushUserPageScene(
                    userId: userId,
                    vm: scene.VM,
                    animated: true
                )
            }.disposed(by: sceneDisposeBag)
    }

    func pushMessageReportScene(vm: MessageRoomViewModel, roomId: Int) {
        let comp = component.reportMessageComponent(roomId: roomId)
        let coord = MessageReportCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord) { coordResult in
            switch coordResult {
            case let .backward(needUpdate):
                vm.routeInputs.needUpdate.onNext(needUpdate)
            case .reportModal:
                vm.routeInputs.report.onNext(roomId)
            }
        }
    }

    func pushDetailPostScene(vm: MessageRoomViewModel, postId: Int) {
        let comp = component.postDetailComponent(postId: postId)
        let coord = PostDetailCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord) { coordResult in
            switch coordResult {
            case let .backward(_, needUpdate):
                vm.routeInputs.needUpdate.onNext(needUpdate)
            }
        }
    }

    private func presentPhotoModal(vm: MessageRoomViewModel, animated: Bool) {
        let comp = component.takePhotoModalComponent
        let coord = TakePhotoModalCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case .takePhoto:
                vm.routeInputs.photoTypeSelected.onNext(.camera)
            case .choosePhoto:
                vm.routeInputs.photoTypeSelected.onNext(.library)
            case .cancel:
                break
            default:
                break
            }
        }
    }

    private func presentImageViewer(
        vm: MessageRoomViewModel,
        image: UIImage
    ) {
        let comp = component.imageViewerComponent(image: image)
        let coord = ImageViewerCoordinator(
            component: comp,
            navController: navigationController
        )

        coordinate(coordinator: coord) { coordResult in
            switch coordResult {
            case .backward:
                vm.routeInputs.needUpdate.onNext(true)
            }
        }
    }

    private func pushUserPageScene(
        userId: Int,
        vm _: MessageRoomViewModel,
        animated: Bool
    ) {
        let comp = component.userPageComponent(userId: userId)
        let coord = UserPageCoordinator(
            component: comp,
            navController: navigationController
        )

        coordinate(
            coordinator: coord,
            animated: animated
        ) { coordResult in
            switch coordResult {
            case .backward:
                print("UserPage coordResult: Backward")
//                vm.routeInputs.needUpdate.onNext(needUpdate)
            }
        }
    }
}
