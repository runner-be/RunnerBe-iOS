//
//  LoginUseCase.swift
//  Runner-be
//
//  Created by 이유리 on 2023/08/28.
//

import Foundation
import RxSwift

final class LoginUseCase {
    private let loginAPIRepo: LoginAPIService = BasicLoginAPIService()
    private let loginRepo: LoginService = BasicLoginService()
    private var loginKeyChainRepo: LoginKeyChainService = BasicLoginKeyChainService.shared
}

extension LoginUseCase {
    // MARK: - Network

    func login(with token: LoginToken) -> Observable<LoginWithTokenResult> {
        return loginAPIRepo.login(with: token)
    }

    func login(with social: SocialLoginType, token: String) -> Observable<LoginAPIResult?> {
        return loginAPIRepo.login(with: social, token: token)
    }
}

extension LoginUseCase {
    // MARK: - KeyChain

    var loginType: LoginType {
        return loginKeyChainRepo.loginType
    }

    var userId: Int? {
        return loginKeyChainRepo.userId
    }
}

// MARK: - Business Logic

extension LoginUseCase {
    func checkLogin() -> Observable<CheckLoginResult> {
        return loginRepo.checkLogin()
    }

    func login(with socialType: SocialLoginType) -> Observable<LoginResult> {
        return loginRepo.login(with: socialType)
    }

    func logout() {
        return loginRepo.logout()
    }
}
