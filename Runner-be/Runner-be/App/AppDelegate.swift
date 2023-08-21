//
//  AppDelegate.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/01/29.
//

import Firebase

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import RxKakaoSDKAuth
import RxKakaoSDKCommon
import RxKakaoSDKUser

import NaverThirdPartyLogin

import RxSwift
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        setupSocialLoginSDKs()
        setupFirebase(application)

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration
    {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {}

    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

// MARK: - 프로젝트 초기 설정

extension AppDelegate {
    private func setupSocialLoginSDKs() {
        RxKakaoSDK.initSDK(appKey: AppKeys.KakaoKey)

        let naverLogin = NaverThirdPartyLoginConnection.getSharedInstance()
        naverLogin?.isNaverAppOauthEnable = false
        naverLogin?.isInAppOauthEnable = true
        naverLogin?.isOnlyPortraitSupportedInIphone()

        naverLogin?.serviceUrlScheme = AppKeys.NaverAppUrlScheme
        naverLogin?.consumerKey = AppKeys.NaverConsumerKey
        naverLogin?.consumerSecret = AppKeys.NaverConsumerSecret
        naverLogin?.appName = AppKeys.NaverAppName
    }

    private func setupFirebase(_ application: UIApplication) {
        FirebaseApp.configure()

        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )

        application.registerForRemoteNotifications()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // Push 알림 수신시 호출
    func userNotificationCenter(_: UNUserNotificationCenter, willPresent _: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        BasicRBNotificationService.shared.sendNotification(type: .pushAlarm)
        completionHandler([.badge, .sound, .alert])
    }

    // Push 알림 선택시 호출
    func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        Log.d(tag: .custom("🔔Notification"), "\n" + response.notification.request.content.userInfo.map {
            "\(($0.key as? String) ?? "-") : \(($0.value as? String) ?? "-")"
        }.joined(separator: "\n"))

        sendNotificationURLToConnectedScene(urlString: response.notification.request.content.userInfo["url"] as? String)
        completionHandler()
    }

    private func sendNotificationURLToConnectedScene(urlString _: String?) {
        let scene = UIApplication.shared.connectedScenes.first
        if let sceneDelegate = scene?.delegate as? SceneDelegate {
            // TODO: sceneDelegate에서 해당 url 딥링크 처리
        }
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Log.d(tag: .info, "FCMToken : \(fcmToken ?? "-")")
        if let fcmToken = fcmToken {
            BasicUserKeyChainService.shared.deviceToken = fcmToken
            BasicUserAPIService().updateFCMToken(to: fcmToken)
        }
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
}
