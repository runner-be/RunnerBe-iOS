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
}

final class SelectGenderCoordinator: BasicCoordinator<SelectGenderResult> {
    // MARK: Lifecycle

    init(component: SelectGenderComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: SelectGenderComponent

    override func start() {
        let selectGender = component.selectGender
        navController.pushViewController(selectGender.VC, animated: true)

        closeSignal
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .backward:
                    self?.navController.popViewController(animated: true)
                case .cancelOnboarding:
                    self?.navController.popViewController(animated: false)
                }
            })
            .disposed(by: disposeBag)

        selectGender.VM.routes.nextProcess
            .subscribe(onNext: { [weak self] in
                self?.pushSelectJobGroupCoord()
            })
            .disposed(by: disposeBag)

        selectGender.VM.routes.cancel
            .subscribe(onNext: { [weak self] in
                self?.presentOnboardingCancelCoord()
            })
            .disposed(by: disposeBag)

        selectGender.VM.routes.backward
            .map { SelectGenderResult.backward }
            .subscribe(closeSignal)
            .disposed(by: disposeBag)
    }

    // MARK: Private

    private func pushSelectJobGroupCoord() {
        let comp = component.selectJobGroupCoord
        let coord = SelectJobGroupCoordinator(component: comp, navController: navController)
        let uuid = coord.uuid

        let disposable = coordinate(coordinator: coord)
            .take(1)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.release(coordinator: coord) }
                switch coordResult {
                case .cancelOnboarding:
                    self?.closeSignal.onNext(.cancelOnboarding)
                case .backward: break
                }
            })

        addChildBag(uuid: uuid, disposable: disposable)
    }

    private func presentOnboardingCancelCoord() {
        let comp = component.onboardingCancelModalComponent
        let coord = OnboardingCancelModalCoordinator(component: comp, navController: navController)
        let uuid = coord.uuid

        let disposable = coordinate(coordinator: coord)
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

        addChildBag(uuid: uuid, disposable: disposable)
    }
}
