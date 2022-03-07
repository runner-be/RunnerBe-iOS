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

import NeedleFoundation
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
               naverAPI.isNaverThirdPartyLoginAppschemeURL(url)
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
                #if DEBUG
                    print("[SceneDelegate][continue userActivity][\(#line)] dynamicLinks: \(String(describing: dynamicLink)) incomingURL: \(incomingURL)")
                #endif
                guard error == nil
                else {
                    #if DEBUG
                        print("[SceneDelegate][continue userActivity][\(#line)] error \(error!.localizedDescription)")
                    #endif
                    return
                }

                if let dynamicLink = dynamicLink {
                    self.handleDynamicLink(dynamicLink: dynamicLink)
                }
            })

            if linkHandled {
                #if DEBUG
                    print("[SceneDelegate][continue userActivity][\(#line)] link handled")
                #endif
            } else {
                #if DEBUG
                    print("[SceneDelegate][continue userActivity][\(#line)] no link handled")
                #endif
            }
        }
    }

    func handleDynamicLink(dynamicLink: DynamicLink) {
        guard let url = dynamicLink.url else { return }
        #if DEBUG
            print("[SceneDelegate][handleIncomingDynamicLink] imcoming link parameter is \(url.absoluteString)")
        #endif

        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        else { return }
        #if DEBUG
            print("[SceneDelegate][handleIncomingDynamicLink] imcoming link path : \"\(String(describing: urlComponents.path))\"")

            print("[SceneDelegate][handleIncomingDynamicLink] imcoming link queryItems :")
            urlComponents.queryItems?.forEach {
                if let value = $0.value {
                    print("\"\($0.name)\": \"\(value)\"")
                }
            }
        #endif

        let paths = urlComponents.path.components(separatedBy: "/")
            .filter { !$0.isEmpty }
        let componets = urlComponents.queryItems?
            .filter { $0.value != nil }
            .reduce(into: [String: String]()) { $0[$1.name] = $1.value }

        guard let name = paths.first,
              let parameters = componets,
              let deepLinkType = DeepLinkType.from(name: name, parameters: parameters)
        else { return }

        switch deepLinkType {
        case .emailCertification:
            appCoordinator?.handleDeepLink(type: deepLinkType)
        }
    }
}
