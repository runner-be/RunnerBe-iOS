//
//  BasicLoginKeyChainService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation
import SwiftKeychainWrapper

final class BasicLoginKeyChainService: LoginKeyChainService {
    static let shared = BasicLoginKeyChainService()

    private init(keychainWrapper: KeychainWrapper = .standard) {
        self.keychainWrapper = keychainWrapper
    }

    let keychainWrapper: KeychainWrapper

    var userId: Int? {
        get {
            return keychainWrapper[.userId]
        }
        set {
            keychainWrapper.remove(forKey: .userId)
            if let id = newValue {
                keychainWrapper.set(id, forKey: KeychainWrapper.Key.userId.rawValue)
            }
        }
    }

    var token: LoginToken? {
        get {
            guard let token: String = keychainWrapper[.loginTokenKey]
            else {
                Log.d(tag: .info, "get token: nil")
                return nil
            }
            let loginToken = LoginToken(jwt: token)
            Log.d(tag: .info, "get token: \(loginToken)")
            return loginToken
        }

        set {
            Log.d(tag: .info, "set token: \(newValue)")
            keychainWrapper.remove(forKey: .loginTokenKey)
            if let loginToken = newValue {
                keychainWrapper.set(loginToken.jwt, forKey: KeychainWrapper.Key.loginTokenKey.rawValue)
            }
        }
    }

    var uuid: String? {
        get {
            return keychainWrapper[.uuid]
        }

        set {
            keychainWrapper.remove(forKey: .uuid)
            if let uuid = newValue {
                keychainWrapper.set(uuid, forKey: KeychainWrapper.Key.uuid.rawValue)
            }
        }
    }

    var loginType: LoginType = .nonMember

    func setLoginInfo(loginType: LoginType, uuid: String?, userID: Int?, token: LoginToken?) {
        self.loginType = loginType
        self.uuid = uuid
        userId = userID
        self.token = token
    }

    func clear() {
        uuid = nil
        token = nil
        userId = nil
        loginType = .nonMember
    }
}

private extension KeychainWrapper.Key {
    static let uuid: KeychainWrapper.Key = "uuid"
    static let loginTokenKey: KeychainWrapper.Key = "LoginTokenKey"
    static let userId: KeychainWrapper.Key = "SignupInfo.uuid"
    static let certificated: KeychainWrapper.Key = "UserCertificated"
}
