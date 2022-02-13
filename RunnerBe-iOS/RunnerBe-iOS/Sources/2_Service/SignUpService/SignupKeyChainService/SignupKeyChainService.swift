//
//  SignupKeyChainService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation

protocol SignupKeyChainService {
    var signupForm: SignupForm { get set }
    var uuid: String { get set }
    var nickName: String { get set }
    var birthDay: Int { get set }
    var job: Job { get set }
    var gender: Gender { get set }
    var officeMail: String? { get set }
    var idCardUrl: String? { get set }
}
