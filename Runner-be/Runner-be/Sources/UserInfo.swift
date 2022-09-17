//
//  JwtToken.swift
//  Runner-be
//
//  Created by 이유리 on 2022/08/05.
//

import Foundation

class UserInfo {
    var loginKeyChainService: LoginKeyChainService
    var token: String
    var userId: Int

    init() {
        loginKeyChainService = BasicLoginKeyChainService.shared

        token = loginKeyChainService.token?.jwt ?? ""
        userId = loginKeyChainService.userId ?? 0
    }
}
