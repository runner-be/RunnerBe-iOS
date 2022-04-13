//
//  HomeFilterCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/16.
//

import Foundation
import RxSwift

enum HomeFilterResult {
    case backward(filter: PostFilter)
}

final class HomeFilterCoordinator: BasicCoordinator<HomeFilterResult> {
    var component: HomeFilterComponent

    init(component: HomeFilterComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated: Bool) {
        let scene = component.scene
        navigationController.pushViewController(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        scene.VM.routes.backward
            .map { HomeFilterResult.backward(filter: $0) }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)
    }
}
