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
            let loginToken = LoginToken(token: token)
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
                keychainWrapper.set(loginToken.token, forKey: KeychainWrapper.Key.loginTokenKey.rawValue)
            }
        }
    }
}

private extension KeychainWrapper.Key {
    static let loginTokenKey: KeychainWrapper.Key = "LoginTokenKey"
}
