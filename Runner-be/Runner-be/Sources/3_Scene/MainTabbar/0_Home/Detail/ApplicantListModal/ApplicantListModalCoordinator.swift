//
//  ApplicantListModalCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/26.
//

import Foundation
import RxSwift

enum ApplicantListModalResult {
    case backward(needUpdate: Bool)
}

final class ApplicantListModalCoordinator: BasicCoordinator<ApplicantListModalResult> {
    var component: ApplicantListModalComponent

    init(component: ApplicantListModalComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated _: Bool) {
        let scene = component.scene
        navigationController.present(scene.VC, animated: true)

        closeSignal
            .subscribe(onNext: { _ in
                scene.VC.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        scene.VM.routes.backward
            .map { ApplicantListModalResult.backward(needUpdate: $0) }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)
    }
}
