//
//  LoginService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation
import RxSwift

enum LoginResult {
    case succeed
    case member
    case memberWaitCertification
    case nonMember(uuid: String)
    case socialLoginFail
    case loginFail
    case stopped
}

enum CheckLoginResult {
    case member
    case memberWaitCertification
    case nonMember
    case stopped
}

protocol LoginService {
    func checkLogin() -> Observable<CheckLoginResult>
    func login(with socialType: SocialLoginType) -> Observable<LoginResult>
    func logout()
}
