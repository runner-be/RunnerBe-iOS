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

    override func start() {
        let scene = component.scene
        navController.pushViewController(scene.VC, animated: true)

        closeSignal
            .subscribe(onNext: { [weak self] result in
                defer { scene.VC.removeFromParent() }
                switch result {
                case .backward:
                    self?.navController.popViewController(animated: true)
                case .cancelOnboarding:
                    self?.navController.popViewController(animated: false)
                }
            })
            .disposed(by: disposeBag)

        scene.VM.routes.photoModal
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.presentPhotoModal(vm: vm)
            })
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

        scene.VM.routes.certificate
            .subscribe(onNext: { [weak self] in
                self?.pushWaitCertificateCoord()
            })
            .disposed(by: disposeBag)
    }

    private func presentPhotoModal(vm: PhotoCertificationViewModel) {
        let comp = component.photoModalComponent
        let coord = PhotoModalCoordinator(component: comp, navController: navController)

        let disposable = coordinate(coordinator: coord)
            .map { $0.imagePickerType }
            .subscribe(onNext: { [weak self] imagePickerType in
                defer { self?.release(coordinator: coord) }
                vm.routeInputs.photoModal.onNext(imagePickerType)
            })

        addChildBag(id: coord.id, disposable: disposable)
    }

    private func presentOnboardingCancelCoord() {
        let comp = component.onboardingCancelModalComponent
        let coord = OnboardingCancelModalCoordinator(component: comp, navController: navController)

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

        addChildBag(id: coord.id, disposable: disposable)
    }

    private func pushWaitCertificateCoord() {
        let comp = component.waitCertificationComponent
        let coord = WaitCertificationCoordinator(component: comp, navController: navController)

        let disposable = coordinate(coordinator: coord)
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                defer { self?.release(coordinator: coord) }
            })

        addChildBag(id: coord.id, disposable: disposable)
    }
}
