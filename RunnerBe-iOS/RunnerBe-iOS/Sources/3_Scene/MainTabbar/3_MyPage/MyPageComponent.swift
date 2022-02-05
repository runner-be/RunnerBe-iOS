//
//  2__3_MyPageComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import NeedleFoundation

protocol MyPageDependency: Dependency {}

final class MyPageComponent: Component<MyPageDependency>
{
    var myPageViewController: UIViewController
    {
        return shared { MyPageViewController() }
    }
}
