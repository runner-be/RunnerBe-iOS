//
//  LoginUseCase.swift
//  Runner-be
//
//  Created by 이유리 on 2023/08/28.
//

import Foundation
import RxSwift

final class LoginUseCase {
    private var loginKeyChainRepo: LoginKeyChainService = BasicLoginKeyChainService.shared

    // MARK: - Network
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
