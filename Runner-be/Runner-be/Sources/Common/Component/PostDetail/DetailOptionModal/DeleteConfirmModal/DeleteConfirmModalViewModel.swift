//
//  DeleteConfirmModalViewModel.swift
//  Runner-be
//
//  Created by 김신우 on 2022/08/08.
//

import Foundation
import RxSwift

final class DeleteConfirmModalViewModel: BaseViewModel {
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
