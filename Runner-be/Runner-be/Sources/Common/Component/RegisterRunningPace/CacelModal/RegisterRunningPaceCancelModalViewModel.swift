//
//  RegisterRunningPaceCancelModalViewModel.swift
//  Runner-be
//
//  Created by 이유리 on 4/16/24.
//

import Foundation
import RxSwift

final class RegisterRunningPaceCancelModalViewModel: BaseViewModel {
    override init() {
        super.init()

        inputs.tapOK
            .bind(to: routes.ok)
            .disposed(by: disposeBag)

        inputs.backward
            .bind(to: routes.backward)
            .disposed(by: disposeBag)
    }

    struct Input {
        var tapOK = PublishSubject<Void>()
        var backward = PublishSubject<Void>()
    }

    struct Route {
        var ok = PublishSubject<Void>()
        var backward = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var routes = Route()
}
