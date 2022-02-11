//
//  EmailCertificationInitModalCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import Foundation
import RxSwift

enum EmailCertificationInitModalResult {
    case backward
}

final class EmailCertificationInitModalCoordinator: BasicCoordinator<EmailCertificationInitModalResult> {
    var component: EmailCertificationInitModalComponent

    init(component: EmailCertificationInitModalComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start() {
        let emailCertificationInitModal = component.emailCertificationInitModal
        emailCertificationInitModal.VC.modalPresentationStyle = .overCurrentContext
        navController.present(emailCertificationInitModal.VC, animated: false)

        closeSignal
            .subscribe(onNext: { _ in
                emailCertificationInitModal.VC.dismiss(animated: false)
            })
            .disposed(by: disposeBag)

        emailCertificationInitModal.VM
            .routes.backward
            .map { EmailCertificationInitModalResult.backward }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)
    }
}
