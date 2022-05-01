//
//  WritingDetailPostCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/21.
//

import Foundation
import RxSwift

enum WritingDetailPostResult {
    case backward
    case apply
}

final class WritingDetailPostCoordinator: BasicCoordinator<WritingDetailPostResult> {
    var component: WritingDetailPostComponent

    init(component: WritingDetailPostComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated _: Bool) {
        let scene = component.scene
        navigationController.pushViewController(scene.VC, animated: true)

        closeSignal
            .debug()
            .subscribe(onNext: { [weak self] _ in
                #if DEBUG
                    print("[WritingDetailPostCoordinator][closeSignal] popViewController")
                #endif

                self?.navigationController.popViewController(animated: false)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.backward
            .map { WritingDetailPostResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.apply
            .map { WritingDetailPostResult.apply }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}