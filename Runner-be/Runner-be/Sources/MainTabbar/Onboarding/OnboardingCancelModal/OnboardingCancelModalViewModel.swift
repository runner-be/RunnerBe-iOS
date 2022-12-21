//
//  OnboardingCancelModalViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import Foundation
import RxSwift

final class OnboardingCancelModalViewModel: BaseViewModel {
    override init() {
        super.init()

        inputs.cancel
            .bind(to: routes.backward)
            .disposed(by: disposeBag)

        inputs.ok
            .bind(to: routes.cancel)
            .disposed(by: disposeBag)
    }

    struct Input {
        var cancel = PublishSubject<Void>()
        var ok = PublishSubject<Void>()
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
