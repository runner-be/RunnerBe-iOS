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
}

final class BirthCoordinator: BasicCoordinator<BirthResult> {
    // MARK: Lifecycle

    init(component: BirthComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: BirthComponent

    override func start() {
        let viewController = component.birthViewController
        navController.pushViewController(viewController, animated: true)

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

        component.birthViewModel.routes.nextProcess
            .subscribe(onNext: {
                self.pushSelectGenderCoord()
            })
            .disposed(by: disposeBag)

        component.birthViewModel.routes.cancel
            .subscribe(onNext: {
                self.presentOnboardingCancelCoord()
            })
            .disposed(by: disposeBag)

        component.birthViewModel.routes.backward
            .map { BirthResult.backward }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)
    }

    // MARK: Private

    private func pushSelectGenderCoord() {
        let selectGenderComp = component.selectGenderComponent

        let selectGenderCoord = SelectGenderCoordinator(component: selectGenderComp, navController: navController)

        coordinate(coordinator: selectGenderCoord)
            .take(1)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.release(coordinator: selectGenderCoord) }
                switch coordResult {
                case .cancelOnboarding:
                    self?.closeSignal.onNext(.cancelOnboarding)
                case .backward: break
                }
            })
            .disposed(by: disposeBag)
    }

    private func presentOnboardingCancelCoord() {
        let cancelModalComp = component.onboardingCancelModalComponent
        let cancelModalCoord = OnboardingCancelModalCoordinator(component: cancelModalComp, navController: navController)

        coordinate(coordinator: cancelModalCoord)
            .take(1)
            .subscribe(onNext: { modalResult in
                defer { self.release(coordinator: cancelModalCoord) }
                switch modalResult {
                case .cancelOnboarding:
                    self.closeSignal.onNext(.cancelOnboarding)
                case .cancelModal:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}
