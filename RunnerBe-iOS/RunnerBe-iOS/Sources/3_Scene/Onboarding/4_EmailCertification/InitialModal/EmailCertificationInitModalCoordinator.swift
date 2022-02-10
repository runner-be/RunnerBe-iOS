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
        let viewController = component.emailCertificationInitModalViewController
        viewController.modalPresentationStyle = .overCurrentContext
        navController.present(viewController, animated: false)

        closeSignal
            .subscribe(onNext: { _ in
                viewController.dismiss(animated: false)
            })
            .disposed(by: disposeBag)

        component.emailCertificationInitModalViewModel
            .routes.backward
            .map { EmailCertificationInitModalResult.backward }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)
    }
}
