//
//  OnboardingCoverViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/04.
//

import Foundation
import RxSwift

final class OnboardingCoverViewModel: BaseViewModel {
    override init() {
        super.init()

        inputs.goOnboard
            .bind(to: routes.goOnboard)
            .disposed(by: disposeBag)

        inputs.lookMain
            .bind(to: routes.lookMain)
            .disposed(by: disposeBag)

        inputs.testCertificated
            .bind(to: routes.testCertificated)
            .disposed(by: disposeBag)
    }

    struct Input {
        var goOnboard = PublishSubject<Void>()
        var lookMain = PublishSubject<Void>()

        var testCertificated = PublishSubject<Void>()
    }

    struct Output {}

    struct Route {
        var goOnboard = PublishSubject<Void>()
        var lookMain = PublishSubject<Void>()
        var testCertificated = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
