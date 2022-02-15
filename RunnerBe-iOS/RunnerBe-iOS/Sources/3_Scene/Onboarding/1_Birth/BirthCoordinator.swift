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
    case toMain(certificated: Bool)
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
        navController.pushViewController(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { [weak self] result in
                #if DEBUG
                    print("[BirthCoordinator][closeSignal] popViewController")
                #endif
                switch result {
                case .backward:
                    self?.navController.popViewController(animated: true)
                case .cancelOnboarding:
                    self?.navController.popViewController(animated: false)
                case .toMain:
                    self?.navController.popViewController(animated: false)
                }
            })
            .disposed(by: disposeBag)

        scene.VM.routes.nextProcess
            .subscribe(onNext: { [weak self] in
                self?.pushSelectGenderCoord(animated: true)
            })
            .disposed(by: disposeBag)

        scene.VM.routes.cancel
            .subscribe(onNext: { [weak self] in
                self?.presentOnboardingCancelCoord(animated: false)
            })
            .disposed(by: disposeBag)

        scene.VM.routes.backward
            .map { BirthResult.backward }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)
    }

    // MARK: Private

    private func pushSelectGenderCoord(animated: Bool) {
        let comp = component.selectGenderComponent

        let coord = SelectGenderCoordinator(component: comp, navController: navController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .take(1)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.release(coordinator: coord) }
                switch coordResult {
                case .cancelOnboarding:
                    self?.closeSignal.onNext(.cancelOnboarding)
                case let .toMain(certificated):
                    self?.closeSignal.onNext(.toMain(certificated: certificated))
                case .backward: break
                }
            })

        addChildBag(id: coord.id, disposable: disposable)
    }

    private func presentOnboardingCancelCoord(animated: Bool) {
        let comp = component.onboardingCancelModalComponent
        let coord = OnboardingCancelModalCoordinator(component: comp, navController: navController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .take(1)
            .subscribe(onNext: { [weak self] modalResult in
                defer { self?.release(coordinator: coord) }
                switch modalResult {
                case .cancelOnboarding:
                    self?.closeSignal.onNext(.cancelOnboarding)
                case .cancelModal:
                    break
                }
            })

        addChildBag(id: coord.id, disposable: disposable)
    }

    override func handleDeepLink(type: DeepLinkType) {
        switch type {
        case .emailCertification:
            if let coord = childs["SelectGenderCoordinator"] {
                coord.handleDeepLink(type: type)
            } else {
                pushSelectGenderCoord(animated: false)
                childs["SelectGenderCoordinator"]!.handleDeepLink(type: type)
            }
        }
    }
}
