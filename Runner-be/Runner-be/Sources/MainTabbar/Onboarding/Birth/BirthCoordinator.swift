//
//  BirthCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/07.
//

import Foundation
import RxSwift

enum BirthResult {
    case cancelOnboarding
    case backward
    case toMain
}

final class BirthCoordinator: BasicCoordinator<BirthResult> {
    // MARK: Lifecycle

    init(component: BirthComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: BirthComponent

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

        scene.VM.routes.nextProcess
            .subscribe(onNext: { [weak self] in
                self?.pushSelectGenderCoord(animated: true)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.cancel
            .subscribe(onNext: { [weak self] in
                self?.presentOnboardingCancelCoord(animated: false)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.backward
            .map { BirthResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }

    // MARK: Private

    private func pushSelectGenderCoord(animated: Bool) {
        let comp = component.selectGenderComponent
        let coord = SelectGenderCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: animated) { [weak self] coordResult in
            switch coordResult {
            case .cancelOnboarding:
                self?.closeSignal.onNext(.cancelOnboarding)
            case .toMain:
                self?.closeSignal.onNext(.toMain)
            case .backward: break
            }
        }
    }

    private func presentOnboardingCancelCoord(animated: Bool) {
        let comp = component.onboardingCancelModalComponent
        let coord = OnboardingCancelModalCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: animated) { [weak self] coordResult in
            switch coordResult {
            case .cancelOnboarding:
                self?.closeSignal.onNext(.cancelOnboarding)
            case .cancelModal:
                break
            }
        }
    }
}
