//
//  MessageDeleteComponent.swift
//  Runner-be
//
//  Created by 이유리 on 2022/05/07.
//

import Foundation
import RxSwift

enum MessageDeleteResult {}

final class MessageDeleteCoordinator: BasicCoordinator<MessageDeleteResult> {
    var component: MessageDeleteComponent

    init(component: MessageDeleteComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated _: Bool) {
//        let scene = component.scene
    }
}
