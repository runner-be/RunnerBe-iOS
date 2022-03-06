//
//  SignoutModalViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/06.
//

import Foundation
import RxSwift

final class SignoutModalViewModel: BaseViewModel {
    override init() {
        super.init()

        inputs.cancel
            .bind(to: routes.cancel)
            .disposed(by: disposeBag)

        inputs.ok
            .bind(to: routes.signout)
            .disposed(by: disposeBag)
    }

    struct Input {
        var cancel = PublishSubject<Void>()
        var ok = PublishSubject<Void>()
    }

    struct Output {}

    struct Route {
        var cancel = PublishSubject<Void>()
        var signout = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
