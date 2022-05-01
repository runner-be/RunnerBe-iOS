//
//  SignoutCompletionModalViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/06.
//

import Foundation
import RxSwift

final class SignoutCompletionModalViewModel: BaseViewModel {
    override init() {
        super.init()

        inputs.move
            .bind(to: routes.toLoginPage)
            .disposed(by: disposeBag)
    }

    struct Input {
        var move = PublishSubject<Void>()
    }

    struct Output {}

    struct Route {
        var toLoginPage = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
