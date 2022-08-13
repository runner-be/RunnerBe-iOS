//
//  JobChangeModalViewModel.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/23.
//

import Foundation
import RxSwift

final class JobChangeModalViewModel: BaseViewModel {
    init(job _: String) {
        super.init()

        inputs.tapOK
            .bind(to: routes.ok)
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
        var ok = PublishSubject<Void>()
        var backward = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
