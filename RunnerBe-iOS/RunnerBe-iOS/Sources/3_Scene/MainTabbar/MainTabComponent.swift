//
//  2__MainTabComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import NeedleFoundation

protocol MainTabDependency: Dependency {}

final class MainTabComponent: Component<MainTabDependency> {
    var scene: UITabBarController {
        return UITabBarController()
    }

    var homeComponent: HomeComponent {
        return HomeComponent(parent: self)
    }

    var bookmarkComponent: BookMarkComponent {
        return BookMarkComponent(parent: self)
    }

    var messageComponent: MessageComponent {
        return MessageComponent(parent: self)
    }

    var myPageComponent: MyPageComponent {
        return MyPageComponent(parent: self)
    }
}
