//
//  RunningTagModalViewModel.swift
//  Runner-be
//
//  Created by 김신우 on 2022/07/27.
//

import Foundation
import RxSwift

final class RunningTagModalViewModel: BaseViewModel {
    override init() {
        super.init()

        inputs.tapOrder
            .bind(to: routes.ok)
            .disposed(by: disposeBag)

        inputs.backward
            .subscribe(routes.backward)
            .disposed(by: disposeBag)
    }

    struct Input {
        var tapOrder = PublishSubject<RunningTag>()
        var backward = PublishSubject<Void>()
    }

    struct Output {}
    struct Route {
        var ok = PublishSubject<RunningTag>()
        var backward = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
