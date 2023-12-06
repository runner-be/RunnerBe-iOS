//
//  SelectJobGroupCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import Foundation
import RxSwift

enum SelectJobGroupResult {
    case cancelOnboarding
    case backward
    case toMain
}

final class SelectJobGroupCoordinator: BasicCoordinator<SelectJobGroupResult> {
    // MARK: Lifecycle

    init(component: SelectJobGroupComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: SelectJobGroupComponent

    override func start(animated: Bool = true) {
        let scene = component.scene
        navigationController.pushViewController(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { [weak self] result in
                Log.d(tag: .lifeCycle, "VC poped")

                switch result {
                case .backward:
                    self?.navigationController.popViewController(animated: true)
                case .cancelOnboarding:
                    self?.navigationController.popViewController(animated: false)
                case .toMain:
                    self?.navigationController.popViewController(animated: false)
                }
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.complete
            .subscribe(onNext: { [weak self] in
                self?.pushOnboardingComplete(animated: true)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.cancel
            .subscribe(onNext: { [weak self] in
                self?.presentOnboardingCancelCoord(animated: false)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.backward
            .map { SelectJobGroupResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }

    // MARK: Private

    private func pushOnboardingComplete(animated: Bool) {
        let comp = component.onboardingCompleteComponent
        let coord = OnboardingCompletionCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: animated) { [weak self] coordResult in
            switch coordResult {
            case .toMain:
                self?.closeSignal.onNext(.toMain)
            }
        }
    }

    private func presentOnboardingCancelCoord(animated: Bool) {
        let comp = component.onboardingCancelModalComponent
        let coord = OnboardingCancelModalCoordinator(component: comp, navController: navigationController)
        let uuid = coord.identifier

        coordinate(coordinator: coord, animated: animated) { [weak self] coordResult in
            switch coordResult {
            case .cancelOnboarding:
                self?.closeSignal.onNext(.cancelOnboarding)
            case .cancelModal:
                break
            }
        }
    }

    override func handleDeepLink(type _: DeepLinkType) {}
}
