//
//  AppContext.swift
//  Runner-be
//
//  Created by 김신우 on 2022/04/26.
//

import UIKit

class AppContext {
    static let shared = AppContext()
    private init() {}

    var rootNavigationController: UINavigationController?

    var safeAreaInsets: UIEdgeInsets = .zero
    let tabHeight: CGFloat = 52
    let navHeight: CGFloat = 44
}
