//
//  LoginKeyChainService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation

protocol LoginKeyChainService {
    var token: LoginToken? { get set }
    var userId: Int? { get set }
    var loginType: LoginType { get set }
    var uuid: String? { get set }

    func setLoginInfo(loginType: LoginType, uuid: String?, userID: Int?, token: LoginToken?)
    func clearIfFirstLaunched()
    func clear()
}
