//
//  LoginKeyChainService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation

protocol LoginKeyChainService {
    var token: LoginToken? { get set }
}