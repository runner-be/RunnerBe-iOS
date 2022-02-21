//
//  3__0_HomeCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import RxSwift
import UIKit

protocol HomeResult {}

final class HomeCoordinator: TabCoordinator<HomeResult> {
    // MARK: Lifecycle

    init(component: HomeComponent, tabController: UITabBarController, navController: UINavigationController) {
        self.component = component
        super.init(tabController: tabController, navController: navController)
    }

    // MARK: Internal

    var component: HomeComponent

    override func start(animated _: Bool = true) {
        var scene = component.scene

        scene.VM.routes.filter
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.pushHomeFilterScene(vm: vm, animated: true)
            })
            .disposed(by: disposeBag)

        scene.VM.routes.writingPost
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.pushWritingPostScene(vm: vm, animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func pushWritingPostScene(vm _: HomeViewModel, animated: Bool) {
        let comp = component.writingPostComponent
        let coord = WritingMainPostCoordinator(component: comp, navController: navController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .debug()
            .subscribe(onNext: { [weak self] _ in
                defer { self?.release(coordinator: coord) }

            })

        addChildBag(id: coord.id, disposable: disposable)
    }

    private func pushHomeFilterScene(vm _: HomeViewModel, animated: Bool) {
        let comp = component.postFilterComponent
        let coord = HomeFilterCoordinator(component: comp, navController: navController)

        let disposable = coordinate(coordinator: coord, animated: animated)
//            .debug()
            .subscribe(onNext: { [weak self] _ in
                defer { self?.release(coordinator: coord) }

            })

        addChildBag(id: coord.id, disposable: disposable)
    }
}
