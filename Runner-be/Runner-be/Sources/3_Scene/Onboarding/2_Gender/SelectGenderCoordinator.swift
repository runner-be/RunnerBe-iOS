//
//  SelectGenderCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import Foundation
import RxSwift

enum SelectGenderResult {
    case cancelOnboarding
    case backward
    case toMain
}

final class SelectGenderCoordinator: BasicCoordinator<SelectGenderResult> {
    // MARK: Lifecycle

    init(component: SelectGenderComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: SelectGenderComponent

    override func start(animated: Bool = true) {
        let scene = component.scene
        navController.pushViewController(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { [weak self] result in
                #if DEBUG
                    print("[SelectGenderCoordinator][closeSignal] popViewController")
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
                self?.pushSelectJobGroupCoord(animated: true)
            })
            .disposed(by: disposeBag)

        scene.VM.routes.cancel
            .subscribe(onNext: { [weak self] in
                self?.presentOnboardingCancelCoord(animated: false)
            })
            .disposed(by: disposeBag)

        scene.VM.routes.backward
            .map { SelectGenderResult.backward }
            .subscribe(closeSignal)
            .disposed(by: disposeBag)
    }

    // MARK: Private

    private func pushSelectJobGroupCoord(animated: Bool) {
        let comp = component.selectJobGroupCoord
        let coord = SelectJobGroupCoordinator(component: comp, navController: navController)
        let uuid = coord.id

        let disposable = coordinate(coordinator: coord, animated: animated)
            .take(1)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.release(coordinator: coord) }
                switch coordResult {
                case .cancelOnboarding:
                    self?.closeSignal.onNext(.cancelOnboarding)
                case let .toMain:
                    self?.closeSignal.onNext(.toMain)
                case .backward: break
                }
            })

        addChildBag(id: uuid, disposable: disposable)
    }

    private func presentOnboardingCancelCoord(animated: Bool) {
        let comp = component.onboardingCancelModalComponent
        let coord = OnboardingCancelModalCoordinator(component: comp, navController: navController)
        let uuid = coord.id

        let disposable = coordinate(coordinator: coord, animated: animated)
            .take(1)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.release(coordinator: coord) }
                switch coordResult {
                case .cancelOnboarding:
                    self?.closeSignal.onNext(.cancelOnboarding)
                case .cancelModal:
                    break
                }
            })

        addChildBag(id: uuid, disposable: disposable)
    }

    override func handleDeepLink(type: DeepLinkType) {
        switch type {
        case .emailCertification:
            if let coord = childs["SelectJobGroupCoordinator"] {
                coord.handleDeepLink(type: type)
            } else {
                pushSelectJobGroupCoord(animated: false)
                childs["SelectJobGroupCoordinator"]!.handleDeepLink(type: type)
            }
        }
    }
}
