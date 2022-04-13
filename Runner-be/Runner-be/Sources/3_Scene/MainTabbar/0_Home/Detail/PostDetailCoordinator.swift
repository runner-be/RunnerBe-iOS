//
//  PostDetailCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/25.
//

import Foundation
import RxSwift

enum PostDetailResult {
    case backward(id: Int, marked: Bool, needUpdate: Bool)
}

final class PostDetailCoordinator: BasicCoordinator<PostDetailResult> {
    var component: PostDetailComponent

    init(component: PostDetailComponent, navController: UINavigationController) {
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
            .disposed(by: disposeBag)

        scene.VM.routes.backward
            .map { PostDetailResult.backward(id: $0.id, marked: $0.marked, needUpdate: $0.needUpdate) }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)

        scene.VM.routes.applicantsModal
            .map { (vm: scene.VM, applicants: $0) }
            .subscribe(onNext: { [weak self] result in
                self?.presentApplicantListModal(vm: result.vm, applicants: result.applicants, animated: true)
            })
            .disposed(by: disposeBag)

        scene.VM.routes.report
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.presentReportModal(vm: vm, animated: false)
            })
            .disposed(by: disposeBag)
    }

    private func presentApplicantListModal(vm: PostDetailViewModel, applicants: [User], animated: Bool) {
        let comp = component.applicantListModal(applicants: applicants)
        let coord = ApplicantListModalCoordinator(component: comp, navController: navigationController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.releaseChild(coordinator: coord) }
                switch coordResult {
                case let .backward(needUpdate):
                    if needUpdate {
                        vm.routeInputs.needUpdate.onNext(())
                    }
                }
            })

        addChildBag(id: coord.identifier, disposable: disposable)
    }

    private func presentReportModal(vm: PostDetailViewModel, animated: Bool) {
        let comp = component.reportModalComponent
        let coord = ReportModalCoordinator(component: comp, navController: navigationController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.releaseChild(coordinator: coord) }
                switch coordResult {
                case .ok:
                    vm.routeInputs.report.onNext(true)
                case .cancel:
                    vm.routeInputs.report.onNext(false)
                }
            })

        addChildBag(id: coord.identifier, disposable: disposable)
    }
}
