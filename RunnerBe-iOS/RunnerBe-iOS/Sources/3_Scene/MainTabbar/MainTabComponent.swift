//
//  2__MainTabComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import NeedleFoundation

protocol MainTabDependency: Dependency {}

final class MainTabComponent: Component<MainTabDependency>
{
    var mainTabbarController: UITabBarController
    {
        return shared { UITabBarController() }
    }

    var homeComponent: HomeComponent
    {
        return shared { HomeComponent(parent: self) }
    }

    var bookmarkComponent: BookMarkComponent
    {
        return shared { BookMarkComponent(parent: self) }
    }

    var messageComponent: MessageComponent
    {
        return shared { MessageComponent(parent: self) }
    }

    var myPageComponent: MyPageComponent
    {
        return shared { MyPageComponent(parent: self) }
    }
}
