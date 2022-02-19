//
//  EmailCertificationInitModalCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import Foundation
import RxSwift

enum SelectTimeModalResult {
    case backward
}

final class SelectTimeModalCoordinator: BasicCoordinator<SelectTimeModalResult> {
    var component: SelectTimeModalComponent

    init(component: SelectTimeModalComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated: Bool = true) {
        let scene = component.scene
        scene.VC.modalPresentationStyle = .overCurrentContext
        navController.present(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { _ in
                scene.VC.dismiss(animated: false)
            })
            .disposed(by: disposeBag)

        scene.VM
            .routes.backward
            .map { SelectTimeModalResult.backward }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)
    }
}
