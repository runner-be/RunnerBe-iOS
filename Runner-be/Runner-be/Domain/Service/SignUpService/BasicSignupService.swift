//
//  BasicSignupService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation
import RxRelay
import RxSwift

final class BasicSignupService: SignupService {
    var loginKeyChainService: LoginKeyChainService
    var userKeyChainService: UserKeychainService
    let signupAPIService: SignupAPIService

    var disposeBag = DisposeBag()

    init(
        loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared,
        userKeyChainService: UserKeychainService = BasicUserKeyChainService.shared,
        signupAPIService: SignupAPIService = BasicSignupAPIService()
    ) {
        self.loginKeyChainService = loginKeyChainService
        self.userKeyChainService = userKeyChainService
        self.signupAPIService = signupAPIService
    }

    func signup() -> Observable<SignupResult> {
        let uuid = userKeyChainService.uuid
        let deviceToken = userKeyChainService.deviceToken
        let birth = userKeyChainService.birthDay
        let gender = userKeyChainService.gender
        let job = userKeyChainService.job

        guard !uuid.isEmpty,
              !deviceToken.isEmpty,
              birth != 0,
              gender != .none,
              job != .none
        else {
            return .just(.fail)
        }

        let signUpStart = ReplaySubject<Void>.create(bufferSize: 1)
        let signUpFinished = ReplaySubject<SignupResult>.create(bufferSize: 1)

        signUpStart.map {
            SignupForm(
                uuid: uuid,
                deviceToken: deviceToken,
                birthday: birth,
                gender: gender,
                job: job
            )
        }
        .flatMap { [unowned self] signupForm in
            self.signupAPIService.signup(with: signupForm)
        }
        .subscribe(onNext: { [weak self] apiResult in
            guard let self = self,
                  let result = apiResult
            else {
                signUpFinished.onNext(.fail)
                return
            }

            switch result {
            case let .succeed(token, userID):
                self.loginKeyChainService.token = LoginToken(jwt: token)
                self.loginKeyChainService.userId = userID
                self.loginKeyChainService.loginType = .member
                signUpFinished.onNext(.success)
            case let .error(code):
                if code == 2009 {
                    signUpStart.onNext(())
                } else {
                    signUpFinished.onNext(.fail)
                }
            }
        })
        .disposed(by: disposeBag)

        signUpStart.onNext(())

        return signUpFinished
            .do(onNext: { [weak self] _ in
                self?.disposeBag = DisposeBag()
            })
    }
}
