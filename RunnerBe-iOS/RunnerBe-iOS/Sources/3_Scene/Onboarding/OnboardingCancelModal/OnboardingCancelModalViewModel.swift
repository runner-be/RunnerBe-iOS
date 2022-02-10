//
//  OnboardingCancelModalViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import Foundation
import RxSwift

final class OnboardingCancelModalViewModel {
    init() {
        inputs.tapBackward
            .bind(to: routes.backward)
            .disposed(by: disposeBag)

        inputs.tapYes
            .bind(to: routes.cancel)
            .disposed(by: disposeBag)
    }

    struct Input {
        var tapBackward = PublishSubject<Void>()
        var tapYes = PublishSubject<Void>()
    }

    struct Output {}

    struct Route {
        var backward = PublishSubject<Void>()
        var cancel = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
