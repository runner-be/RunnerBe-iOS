//
//  2__LoggedOutCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import Foundation
import RxSwift

enum LoggedOutResult {
    case loginSuccess(isCertificated: Bool)
}

final class LoggedOutCoordinator: BasicCoordinator<LoggedOutResult> {
    // MARK: Lifecycle

    init(component: LoggedOutComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: LoggedOutComponent

    override func start(animated: Bool = true) {
        let scene = component.scene
        navController.pushViewController(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { [weak self] result in
                defer { scene.VC.removeFromParent() }
                switch result {
                case .loginSuccess:
                    self?.navController.popViewController(animated: false)
                }
            })
            .disposed(by: disposeBag)

        scene.VM.routes.nonMember
            .subscribe(onNext: { [weak self] in
                self?.pushPolicyTerm(animated: true)
            })
            .disposed(by: disposeBag)

        scene.VM.routes.loginSuccess
            .subscribe(onNext: { [weak self] isCertificated in
                self?.closeSignal.onNext(.loginSuccess(isCertificated: isCertificated))
            })
            .disposed(by: disposeBag)
    }

    // MARK: Private

    private func pushPolicyTerm(animated: Bool) {
        let comp = component.policyTermComponent
        let coord = PolicyTermCoordinator(component: comp, navController: navController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .take(1)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.release(coordinator: coord) }
                switch coordResult {
                case let .toMain(certificated):
                    self?.closeSignal.onNext(.loginSuccess(isCertificated: certificated))
                case .backward, .cancelOnboarding:
                    break
                }
            })

        addChildBag(id: coord.id, disposable: disposable)
    }

    override func handleDeepLink(type: DeepLinkType) {
        switch type {
        case .emailCertification:
            if let coord = childs["PolicyTermCoordinator"] {
                coord.handleDeepLink(type: type)
            } else {
                pushPolicyTerm(animated: false)
                childs["PolicyTermCoordinator"]!.handleDeepLink(type: type)
            }
        }
    }
}
