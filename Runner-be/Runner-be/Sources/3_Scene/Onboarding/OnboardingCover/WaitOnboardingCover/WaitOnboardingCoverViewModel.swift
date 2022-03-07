//
//  WaitOnboardingCoverViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/05.
//

import Foundation
import RxSwift

final class WaitOnboardingCoverViewModel: BaseViewModel {
    override init() {
        super.init()

        inputs.toMain
            .bind(to: routes.toMain)
            .disposed(by: disposeBag)
    }

    struct Input {
        var toMain = PublishSubject<Void>()
    }

    struct Output {}

    struct Route {
        var toMain = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
