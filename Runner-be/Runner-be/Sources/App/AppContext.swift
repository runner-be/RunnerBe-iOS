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

    var safeAreaInsets: UIEdgeInsets = .zero
    var tabHeight: CGFloat = 52
    var navHeight: CGFloat = 44
}
