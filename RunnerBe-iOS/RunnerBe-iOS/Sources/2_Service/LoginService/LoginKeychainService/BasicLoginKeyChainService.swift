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
            guard let token: String = keychainWrapper[.loginTokenKey]
            else { return nil }
            return LoginToken(token: token)
        }

        set {
            if let loginToken = newValue {
                keychainWrapper.remove(forKey: .loginTokenKey)
                keychainWrapper.set(loginToken.token, forKey: KeychainWrapper.Key.loginTokenKey.rawValue)
            }
        }
    }
}

private extension KeychainWrapper.Key {
    static let loginTokenKey: KeychainWrapper.Key = "LoginTokenKey"
}
