//
//  3__1_BookMarkCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import RxSwift

protocol BookMarkResult {}

final class BookMarkCoordinator: BasicCoordinator<BookMarkResult> {
    // MARK: Lifecycle

    init(component: BookMarkComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: BookMarkComponent

    override func start(animated _: Bool = true) {
        let scene = component.scene

        scene.VM.routes.detailPost
            .map { (vm: scene.VM, postId: $0) }
            .subscribe(onNext: { [weak self] input in
                self?.pushDetailPostScene(vm: input.vm, postId: input.postId, animated: true)
            })
            .disposed(by: sceneDisposeBag)
    }

    private func pushDetailPostScene(vm: BookMarkViewModel, postId: Int, animated: Bool) {
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
}
