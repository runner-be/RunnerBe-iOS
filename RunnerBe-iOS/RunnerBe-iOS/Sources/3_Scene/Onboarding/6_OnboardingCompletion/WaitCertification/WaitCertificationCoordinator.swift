//
//  WaitCertificationCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import Foundation
import RxSwift

enum WaitCertificationResult {
    case toMain(certificated: Bool)
}

final class WaitCertificationCoordinator: BasicCoordinator<WaitCertificationResult> {
    var component: WaitCertificationComponent

    init(component: WaitCertificationComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated: Bool = true) {
        let scene = component.scene
        navController.pushViewController(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { [weak self] result in
                #if DEBUG
                    print("[WaitCertificationCoordinator][closeSignal] popViewController")
                #endif
                switch result {
                case .toMain:
                    self?.navController.popViewController(animated: false)
                }
            })
            .disposed(by: disposeBag)

        scene.VM.routes.toMain
            .map { .toMain(certificated: $0) }
            .subscribe(closeSignal)
            .disposed(by: disposeBag)
    }
}
