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

        let navController = UINavigationController()
        window.rootViewController = navController

        let appComponent = AppComponent()
        let appCoordinator = AppCoordinator(component: appComponent, navController: navController)

        // TEST: token 초기화
        BasicLoginKeyChainService().token = nil

        // TODO: appComponent에서 회원가입여부 확인 후 Main, Logged out 결정
        appComponent.loginService.checkLogin()
            .subscribe(onNext: { result in
                switch result {
                case .member:
                    appCoordinator.showMain(certificated: true)
                case .memberWaitCertification:
                    appCoordinator.showMain(certificated: false)
                case .nonMember:
                    appCoordinator.showLoggedOut()
                }
            })
            .disposed(by: disposeBag)

        window.makeKeyAndVisible()

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
                handleIncomingDynamicLink(dynamicLink: dynamicLink)
            }
        }
    }

    func scene(_: UIScene, continue userActivity: NSUserActivity) {
        if let incomingURL = userActivity.webpageURL {
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL, completion: { dynamicLink, _ in
                #if DEBUG
                    print("[SceneDelegate][continue userActivity] dynamicLinks: \(dynamicLink)")
                #endif
                if let dynamicLink = dynamicLink {
                    self.handleIncomingDynamicLink(dynamicLink: dynamicLink)
                }

            })
        }
    }

    func handleIncomingDynamicLink(dynamicLink: DynamicLink) {
        guard let url = dynamicLink.url else { return }
        #if DEBUG
            print("[SceneDelegate][handleIncomingDynamicLink] imcoming link parameter is \(url.absoluteString)")
        #endif

//        guard
//            dynamicLink.matchType == .unique || dynamicLink.matchType == .default
//        else {
//            #if DEBUG
//                print("[SceneDelegate][handleIncomingDynamicLink] matchType != .unique != .default")
//            #endif
//            return
//        }
//
//        let deepLinkHandler = DeeplinkHander()
//        guard let deepLink = deepLinkHandler.parseComponents(from: url)
//        else {
//            #if DEBUG
//                print("[SceneDelegate][handleIncomingDynamicLink] deepLinkHandler parseComponent = \"nil\"")
//            #endif
//            return
//        }
    }
}
