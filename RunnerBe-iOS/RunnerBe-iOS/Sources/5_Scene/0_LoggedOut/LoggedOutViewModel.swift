//
//  LoggedOutViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import Foundation
import RxSwift

final class LoggedOutViewModel {
    struct Input {
        let kakaoLogin = PublishSubject<Void>()
        let naverLogin = PublishSubject<Void>()
        let appleLogin = PublishSubject<Void>()
    }

    struct Output {
        let loginFail = PublishSubject<Void>()
    }

    struct Route {
        let loginSuccess = PublishSubject<Void>()
    }

    let kakaoOAuthService: KakaoOAuthServicable

    init(kakaoOAuthService: KakaoOAuthServicable) {
        self.kakaoOAuthService = kakaoOAuthService
        input.kakaoLogin.subscribe(onNext: {
            kakaoOAuthService.login()
        }).disposed(by: disposeBag)
    }

    let disposeBag = DisposeBag()
    let input = Input()
    let output = Output()
    let route = Route()
}
