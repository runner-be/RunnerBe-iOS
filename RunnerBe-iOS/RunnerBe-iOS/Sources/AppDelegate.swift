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
    var appCoordinator: AppCoordinator?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerProviderFactories()
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        let navController = UINavigationController()
        window.rootViewController = navController
        let appCoordinator = AppCoordinator(navController: navController)

        window.makeKeyAndVisible()
        self.appCoordinator = appCoordinator
        return true
    }
}
