//
//  2__0HomeComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import NeedleFoundation

protocol HomeDependency: Dependency {}

final class HomeComponent: Component<HomeDependency> {
    var homeViewController: UIViewController {
        return shared { HomeViewController() }
    }
}
