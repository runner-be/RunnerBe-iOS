//
//  ConfirmModalViewModel.swift
//  Runner-be
//
//  Created by 이유리 on 2/16/24.
//

import Foundation
import RxSwift

final class ConfirmModalViewModel: BaseViewModel {
    override init() {
        super.init()

        inputs.ok
            .bind(to: routes.ok)
            .disposed(by: disposeBag)
    }

    struct Input {
        var cancel = PublishSubject<Void>()
        var ok = PublishSubject<Void>()
    }

    struct Output {}

    struct Route {
        var cancel = PublishSubject<Void>()
        var ok = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
