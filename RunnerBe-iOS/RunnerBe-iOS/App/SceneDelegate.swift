//
//  SceneDelegate.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/01/29.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let firstViewController = ViewController()
        window.rootViewController = firstViewController
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_: UIScene) {}

    func sceneDidBecomeActive(_: UIScene) {
        // Called when the scene has moved fr
    }

    func sceneWillResignActive(_: UIScene) {
        // Called when the scene will move from an
    }

    func sceneWillEnterForeground(_: UIScene) {}

    func sceneDidEnterBackground(_: UIScene) {}
}
