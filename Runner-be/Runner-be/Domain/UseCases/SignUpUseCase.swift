//
//  SignUpUseCase.swift
//  Runner-be
//
//  Created by 이유리 on 2023/08/28.
//

import Foundation
import RxSwift

final class SignUpUseCase {
    private var signupRepo: SignupService = BasicSignupService()

    // MARK: - Network

    func signup() -> Observable<SignupResult> {
        return signupRepo.signup()
    }
}

extension SignUpUseCase {
    // MARK: - KeyChain
}
