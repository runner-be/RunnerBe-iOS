//
//  LoggedOutViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import Foundation
import RxSwift

final class LoggedOutViewModel: BaseViewModel {
    // MARK: Lifecycle

    init(
        kakaoLoginService: LoginServiceable,
        naverLoginService: LoginServiceable
    ) {
        kakaoNaverService = kakaoLoginService
        self.naverLoginService = naverLoginService
        super.init()

        input.kakaoLogin.subscribe(onNext: {
            _ = kakaoLoginService.login()
        })
        .disposed(by: disposeBag)

        input.naverLogin.subscribe(onNext: {
            _ = naverLoginService.login()
        })
        .disposed(by: disposeBag)

        input.appleLogin.subscribe(onNext: {
            self.route.loginSuccess.onNext(())
        })
        .disposed(by: disposeBag)
    }

    // MARK: Internal

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

    let kakaoNaverService: LoginServiceable
    let naverLoginService: LoginServiceable

    let disposeBag = DisposeBag()
    let input = Input()
    let output = Output()
    let route = Route()
}
