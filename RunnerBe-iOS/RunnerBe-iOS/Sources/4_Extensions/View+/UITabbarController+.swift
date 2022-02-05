//
//  UITabbarController+Configure.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import UIKit

extension UITabBarController {
    func setColors(iconNormal: UIColor, selected: UIColor) {
        let appearance = UITabBarAppearance()

        appearance.stackedLayoutAppearance.normal.iconColor = iconNormal
        appearance.stackedLayoutAppearance.normal.badgeBackgroundColor = .white
        appearance.stackedLayoutAppearance.selected.iconColor = selected
        appearance.stackedLayoutAppearance.selected.badgeBackgroundColor = .white

        tabBar.standardAppearance = appearance
    }
}
