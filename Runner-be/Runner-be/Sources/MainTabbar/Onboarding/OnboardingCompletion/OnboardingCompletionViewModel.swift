//
//  OnboardingCompletionViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import Foundation
import RxSwift

final class OnboardingCompletionViewModel: BaseViewModel {
    override init() {
        super.init()

        inputs.tapStart
            .subscribe(routes.toMain)
            .disposed(by: disposeBag)
    }

    struct Input {
        let tapStart = PublishSubject<Void>()
    }

    struct Output {}
    struct Route {
        let toMain = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
