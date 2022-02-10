//
//  PhotoCertificationCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import Foundation
import RxSwift

enum PhotoCertificationResult {
    case cancelOnboarding
    case backward
}

final class PhotoCertificationCoordinator: BasicCoordinator<PhotoCertificationResult> {
    var component: PhotoCertificationComponent

    init(component: PhotoCertificationComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start() {
        let viewController = component.photoCertificationViewController
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

        component.photoCertificationViewModel
            .routes.photoModal
            .flatMap { self.presentPhotoModal() }
            .subscribe(component.photoCertificationViewModel.routeInputs.photoModal)
            .disposed(by: disposeBag)

        component.photoCertificationViewModel
            .routes.cancel
            .subscribe(onNext: {
                self.presentOnboardingCancelCoord()
            })
            .disposed(by: disposeBag)

        component.photoCertificationViewModel
            .routes.backward
            .map { PhotoCertificationResult.backward }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)
    }

    private func presentPhotoModal() -> Observable<ImagePickerType?> {
        let comp = component.photoModalComponent
        let coord = PhotoModalCoordinator(component: comp, navController: navController)

        return coordinate(coordinator: coord)
            .take(1)
            .flatMap { coordResult -> Observable<ImagePickerType?> in
                defer { self.release(coordinator: coord) }
                switch coordResult {
                case .takePhoto:
                    return .just(.camera)
                case .choosePhoto:
                    return .just(.library)
                case .cancel:
                    return .just(nil)
                }
            }
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
