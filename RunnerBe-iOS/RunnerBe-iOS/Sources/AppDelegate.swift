//
//  AppDelegate.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/01/29.
//

import NeedleFoundation
import RxSwift
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerProviderFactories()
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        return true
    }
}
