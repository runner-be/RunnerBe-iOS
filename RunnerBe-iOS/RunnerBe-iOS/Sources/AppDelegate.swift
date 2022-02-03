//
//  AppDelegate.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/01/29.
//

import NeedleFoundation
import RxSwift
import UIKit
import KakaoSDKAuth

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
        appCoordinator.start()
        window.makeKeyAndVisible()
        self.appCoordinator = appCoordinator
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if(AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }
}
