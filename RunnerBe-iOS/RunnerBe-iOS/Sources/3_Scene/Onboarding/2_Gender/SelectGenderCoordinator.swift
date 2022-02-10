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
        let viewController = component.selectGenderViewController
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

        component.selectGenderViewModel.routes.nextProcess
            .subscribe(onNext: {
                self.pushSelectJobGroupCoord()
            })
            .disposed(by: disposeBag)

        component.selectGenderViewModel.routes.cancel
            .subscribe(onNext: {
                self.presentOnboardingCancelCoord()
            })
            .disposed(by: disposeBag)

        component.selectGenderViewModel.routes.backward
            .map { SelectGenderResult.backward }
            .subscribe(closeSignal)
            .disposed(by: disposeBag)
    }

    // MARK: Private

    private func pushSelectJobGroupCoord() {
        let selectJobGroupComp = component.selectJobGroupCoord

        let selectJobGroupCoord = SelectJobGroupCoordinator(component: selectJobGroupComp, navController: navController)

        coordinate(coordinator: selectJobGroupCoord)
            .take(1)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.release(coordinator: selectJobGroupCoord) }
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
            .subscribe(onNext: { coordResult in
                defer { self.release(coordinator: cancelModalCoord) }
                switch coordResult {
                case .cancelOnboarding:
                    self.closeSignal.onNext(.cancelOnboarding)
                case .cancelModal:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}
