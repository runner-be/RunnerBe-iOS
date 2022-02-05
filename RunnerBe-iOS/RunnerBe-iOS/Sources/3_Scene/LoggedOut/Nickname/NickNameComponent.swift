//
//  NickNameComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import NeedleFoundation

protocol NickNameDependency: Dependency {}

final class NickNameComponent: Component<NickNameDependency>
{
    var nickNameViewController: UIViewController
    {
        return NickNameViewController()
    }
}
