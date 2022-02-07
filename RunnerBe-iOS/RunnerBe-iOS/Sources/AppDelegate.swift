//
//  AppDelegate.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/01/29.
//

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import RxKakaoSDKAuth
import RxKakaoSDKCommon
import RxKakaoSDKUser

import NaverThirdPartyLogin

import NeedleFoundation
import RxSwift
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        registerProviderFactories()
        RxKakaoSDK.initSDK(appKey: AppKeys.KakaoKey)

        let naverLogin = NaverThirdPartyLoginConnection.getSharedInstance()
        naverLogin?.isNaverAppOauthEnable = true
        naverLogin?.isInAppOauthEnable = true
        naverLogin?.isOnlyPortraitSupportedInIphone()
        naverLogin?.serviceUrlScheme = kServiceAppUrlScheme
        naverLogin?.consumerKey = kConsumerKey
        naverLogin?.consumerSecret = kConsumerSecret
        naverLogin?.appName = kServiceAppName

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration
    {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {}
}
