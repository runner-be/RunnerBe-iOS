//
//  PhotoCertificationCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import Foundation
import RxSwift

enum PhotoCertificationResult {}

final class PhotoCertificationCoordinator: BasicCoordinator<PhotoCertificationResult> {
    var component: PhotoCertificationComponent

    init(component: PhotoCertificationComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start() {
        navController.pushViewController(component.photoCertificationViewController, animated: true)
    }
}
