//
//  RegisterRunningPaceViewModel.swift
//  Runner-be
//
//  Created by 이유리 on 2/12/24.
//

import Foundation
import RxSwift

final class RegisterRunningPaceViewModel: BaseViewModel {
    override init() {
        super.init()

        inputs.close
            .bind(to: routes.close)
            .disposed(by: disposeBag)
    }

    struct Input {
        var close = PublishSubject<Void>()
    }

    struct Output {}

    struct Route {
        var close = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
