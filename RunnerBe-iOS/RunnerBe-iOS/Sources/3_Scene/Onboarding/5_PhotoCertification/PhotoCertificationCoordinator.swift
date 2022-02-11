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
        let scene = component.scene
        navController.pushViewController(scene.VC, animated: true)

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

        scene.VM.routes.photoModal
            .flatMap { [weak self] in self?.presentPhotoModal() ?? .just(nil) }
            .subscribe(scene.VM.routeInputs.photoModal)
            .disposed(by: disposeBag)

        scene.VM.routes.cancel
            .subscribe(onNext: { [weak self] in
                self?.presentOnboardingCancelCoord()
            })
            .disposed(by: disposeBag)

        scene.VM.routes.backward
            .map { PhotoCertificationResult.backward }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)
    }

    private func presentPhotoModal() -> Observable<ImagePickerType?> {
        let comp = component.photoModalComponent
        let coord = PhotoModalCoordinator(component: comp, navController: navController)

        return coordinate(coordinator: coord)
            .debug()
            .map { [weak self] coordResult in
                defer { self?.release(coordinator: coord) }
                switch coordResult {
                case .cancel:
                    return nil
                case .choosePhoto:
                    return .library
                case .takePhoto:
                    return .camera
                }
            }
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
