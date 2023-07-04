//
//  SceneDelegate.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

import NaverThirdPartyLogin
import RxSwift

import FirebaseDynamicLinks

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    var appComponent: AppComponent?
    var disposeBag = DisposeBag()

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options connectionOptions: UIScene.ConnectionOptions)
    {
        guard let windowScene = (scene as? UIWindowScene)
        else { return }
        let window = UIWindow(windowScene: windowScene)
        window.overrideUserInterfaceStyle = .dark
        AppContext.shared.safeAreaInsets = window.safeAreaInsets

        let appComponent = AppComponent()
        let appCoordinator = AppCoordinator(component: appComponent, window: window)
        appCoordinator.start()

        self.window = window
        self.appComponent = appComponent
        self.appCoordinator = appCoordinator

        if let userActivity = connectionOptions.userActivities.first {
            self.scene(scene, continue: userActivity)
        }
    }

    func scene(_: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url)
            }

            if let naverAPI = NaverThirdPartyLoginConnection.getSharedInstance(),
               naverAPI.serviceUrlScheme == url.absoluteString
            {
                naverAPI.receiveAccessToken(url)
            }

            if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
                handleDynamicLink(dynamicLink: dynamicLink)
            }
        }
    }

    func scene(_: UIScene, continue userActivity: NSUserActivity) {
        if let incomingURL = userActivity.webpageURL {
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL, completion: { dynamicLink, error in
                Log.d(tag: .lifeCycle, "dynamicLinks: \(String(describing: dynamicLink)) incomingURL: \(incomingURL)")
                if let error = error {
                    Log.e("error: \(error.localizedDescription)")
                    return
                }

                if let dynamicLink = dynamicLink {
                    self.handleDynamicLink(dynamicLink: dynamicLink)
                }
            })

            Log.d(tag: .lifeCycle, "linked handled: \(linkHandled)")
        }
    }

    func handleDynamicLink(dynamicLink: DynamicLink) {
        guard let url = dynamicLink.url else { return }
        Log.d(tag: .lifeCycle, "imcoming link url: \(url.absoluteString)")

        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        else { return }
        Log.d(tag: .lifeCycle, "incoming link urlComponent: \(String(describing: urlComponents))")

        let paths = urlComponents.path.components(separatedBy: "/")
            .filter { !$0.isEmpty }
        let componets = urlComponents.queryItems?
            .filter { $0.value != nil }
            .reduce(into: [String: String]()) { $0[$1.name] = $1.value }

        guard let name = paths.first,
              let parameters = componets,
              let deepLinkType = DeepLinkType.from(name: name, parameters: parameters)
        else { return }

//        switch deepLinkType {
//        case .emailCertification:
//            appCoordinator?.handleDeepLink(type: deepLinkType)
//        }
    }
}
