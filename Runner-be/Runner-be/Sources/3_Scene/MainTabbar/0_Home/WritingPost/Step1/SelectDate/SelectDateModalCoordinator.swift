//
//  EmailCertificationInitModalCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import Foundation
import RxSwift

enum SelectDateModalResult {
    case cancel
    case apply(String)
}

final class SelectDateModalCoordinator: BasicCoordinator<SelectDateModalResult> {
    var component: SelectDateModalComponent

    init(component: SelectDateModalComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated: Bool = true) {
        let scene = component.scene
        scene.VC.modalPresentationStyle = .overCurrentContext
        navigationController.present(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { _ in
                scene.VC.dismiss(animated: false)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM
            .routes.cancel
            .map { SelectDateModalResult.cancel }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM
            .routes.apply
            .map { SelectDateModalResult.apply($0) }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}
