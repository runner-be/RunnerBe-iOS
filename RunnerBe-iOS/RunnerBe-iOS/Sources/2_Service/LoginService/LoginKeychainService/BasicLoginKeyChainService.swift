//
//  BasicLoginKeyChainService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation
import SwiftKeychainWrapper

final class BasicLoginKeyChainService: LoginKeyChainService {
    let keychainWrapper: KeychainWrapper

    init(keychainWrapper: KeychainWrapper = .standard) {
        self.keychainWrapper = keychainWrapper
    }

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
            #if DEBUG
                print("[BasicLoginKeyChainService][token] get")
            #endif
            guard let token: String = keychainWrapper[.loginTokenKey]
            else {
                #if DEBUG
                    print("\t= \"\"")
                #endif
                return nil
            }
            let loginToken = LoginToken(jwt: token)
            #if DEBUG
                print("\t= \"\(loginToken)\"")
            #endif
            return loginToken
        }

        set {
            #if DEBUG
                print("[BasicLoginKeyChainService][token] set\n\t= \"\(newValue)\"")
            #endif
            keychainWrapper.remove(forKey: .loginTokenKey)
            if let loginToken = newValue {
                keychainWrapper.set(loginToken.jwt, forKey: KeychainWrapper.Key.loginTokenKey.rawValue)
            }
        }
    }

    var certificated: Bool = false
}

private extension KeychainWrapper.Key {
    static let loginTokenKey: KeychainWrapper.Key = "LoginTokenKey"
    static let userId: KeychainWrapper.Key = "SignupInfo.uuid"
    static let certificated: KeychainWrapper.Key = "UserCertificated"
}
