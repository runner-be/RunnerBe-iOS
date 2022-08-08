//
//  DetailOptionModalViewModel.swift
//  Runner-be
//
//  Created by 김신우 on 2022/08/08.
//

import Foundation
import RxSwift

final class DetailOptionModalViewModel: BaseViewModel {
    override init() {
        super.init()

        inputs.tapDelete
            .bind(to: routes.delete)
            .disposed(by: disposeBag)

        inputs.backward
            .subscribe(routes.backward)
            .disposed(by: disposeBag)
    }

    struct Input {
        var tapDelete = PublishSubject<Void>()
        var backward = PublishSubject<Void>()
    }

    struct Output {}
    struct Route {
        var delete = PublishSubject<Void>()
        var backward = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
