//
//  NickNameChangeModalViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import Foundation
import RxSwift

final class NickNameChangeModalViewModel: BaseViewModel {
    override init() {
        super.init()

        inputs.tapOK
            .bind(to: routes.backward)
            .disposed(by: disposeBag)

        inputs.backward
            .subscribe(routes.backward)
            .disposed(by: disposeBag)
    }

    struct Input {
        var tapOK = PublishSubject<Void>()
        var backward = PublishSubject<Void>()
    }

    struct Output {}
    struct Route {
        var backward = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
