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
    case toMain
}

extension PhotoModalResult {
    var imagePickerType: ImagePickerType? {
        switch self {
        case .cancel:
            return nil
        case .choosePhoto:
            return .library
        case .takePhoto:
            return .camera
        }
    }
}

final class PhotoCertificationCoordinator: BasicCoordinator<PhotoCertificationResult> {
    var component: PhotoCertificationComponent

    init(component: PhotoCertificationComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated: Bool = true) {
        let scene = component.scene
        navigationController.pushViewController(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { [weak self] result in
                #if DEBUG
                    print("[PhotoCertificationCoordinator][closeSignal] popViewController")
                #endif
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

        scene.VM.routes.photoModal
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.presentPhotoModal(vm: vm, animated: false)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.cancel
            .subscribe(onNext: { [weak self] in
                self?.presentOnboardingCancelCoord(animated: false)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.backward
            .map { PhotoCertificationResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.certificate
            .subscribe(onNext: { [weak self] in
                self?.pushWaitCertificateCoord(animated: true)
            })
            .disposed(by: sceneDisposeBag)
    }

    private func presentPhotoModal(vm: PhotoCertificationViewModel, animated: Bool) {
        let comp = component.photoModalComponent
        let coord = PhotoModalCoordinator(component: comp, navController: navigationController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .map { $0.imagePickerType }
            .subscribe(onNext: { [weak self] imagePickerType in
                defer { self?.releaseChild(coordinator: coord) }
                vm.routeInputs.photoModal.onNext(imagePickerType)
            })

        addChildDisposable(id: coord.identifier, disposable: disposable)
    }

    private func presentOnboardingCancelCoord(animated: Bool) {
        let comp = component.onboardingCancelModalComponent
        let coord = OnboardingCancelModalCoordinator(component: comp, navController: navigationController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .take(1)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.releaseChild(coordinator: coord) }
                switch coordResult {
                case .cancelOnboarding:
                    self?.closeSignal.onNext(.cancelOnboarding)
                case .cancelModal:
                    break
                }
            })

        addChildDisposable(id: coord.identifier, disposable: disposable)
    }

    private func pushWaitCertificateCoord(animated: Bool) {
        let comp = component.waitCertificationComponent
        let coord = WaitCertificationCoordinator(component: comp, navController: navigationController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .take(1)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.releaseChild(coordinator: coord) }
                switch coordResult {
                case .toMain:
                    self?.closeSignal.onNext(PhotoCertificationResult.toMain)
                }
            })

        addChildDisposable(id: coord.identifier, disposable: disposable)
    }
}
