//
//  PostDetailCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/25.
//

import Foundation
import RxSwift

enum PostDetailResult {
    case backward(id: Int, marked: Bool)
}

final class PostDetailCoordinator: BasicCoordinator<PostDetailResult> {
    var component: PostDetailComponent

    init(component: PostDetailComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated _: Bool) {
        let scene = component.scene
        navController.pushViewController(scene.VC, animated: true)

        closeSignal
            .subscribe(onNext: { [weak self] _ in
                self?.navController.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        scene.VM.routes.backward
            .map { PostDetailResult.backward(id: $0.id, marked: $0.marked) }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)

        scene.VM.routes.applicantsModal
            .map { (vm: scene.VM, applicants: $0) }
            .subscribe(onNext: { [weak self] result in
                self?.presentApplicantListModal(vm: result.vm, applicants: result.applicants, animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func presentApplicantListModal(vm _: PostDetailViewModel, applicants: [User], animated: Bool) {
        let comp = component.applicantListModal(applicants: applicants)
        let coord = ApplicantListModalCoordinator(component: comp, navController: navController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] _ in
                defer { self?.release(coordinator: coord) }
            })

        addChildBag(id: coord.id, disposable: disposable)
    }
}
