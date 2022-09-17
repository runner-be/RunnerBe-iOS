//
//  JwtToken.swift
//  Runner-be
//
//  Created by 이유리 on 2022/08/05.
//

import Foundation

final class UserInfo {
    var loginKeyChainService: LoginKeyChainService
    var token: String
    var userId: Int

    init(loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared) {
        self.loginKeyChainService = loginKeyChainService

        token = self.loginKeyChainService.token?.jwt ?? ""
        userId = self.loginKeyChainService.userId ?? 0
    }
}
