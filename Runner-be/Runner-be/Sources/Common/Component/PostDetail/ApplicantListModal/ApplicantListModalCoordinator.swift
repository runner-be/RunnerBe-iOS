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
    case userPage(userId: Int)
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
            .subscribe(onNext: { routeResult in
                switch routeResult {
                case let .backward(needUpdate):
                    scene.VC.dismiss(animated: true, completion: nil)
                case let .userPage(userId):
                    scene.VC.dismiss(animated: true, completion: nil)
                }
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.backward
            .map { ApplicantListModalResult.backward(needUpdate: $0) }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.userPage
            .map { ApplicantListModalResult.userPage(userId: $0) }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}
