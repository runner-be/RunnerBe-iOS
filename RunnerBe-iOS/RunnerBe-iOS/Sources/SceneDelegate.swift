//
//  SceneDelegate.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

import NeedleFoundation
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    var appComponent: AppComponent?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        let navController = UINavigationController()
        window.rootViewController = navController

        let appComponent = AppComponent()
        let appCoordinator = AppCoordinator(component: appComponent, navController: navController)

        // TODO: appComponent에서 회원가입여부 확인 후 Main, Logged out 결정
        appCoordinator.showLoggedOut()
        // TODO-END

        window.makeKeyAndVisible()

        self.window = window
        self.appComponent = appComponent
        self.appCoordinator = appCoordinator
    }

    func scene(_: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
}
