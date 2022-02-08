//
//  SelectJobGroupViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import Foundation
import RxSwift

final class SelectJobGroupViewModel {
    // MARK: Lifecycle

    init() {
        inputs.tapCancel
            .subscribe(routes.cancel)
            .disposed(by: disposeBag)

        inputs.tapBackward
            .subscribe(routes.backward)
            .disposed(by: disposeBag)

        inputs.tapNext
            .subscribe(routes.nextProcess)
            .disposed(by: disposeBag)
    }

    // MARK: Internal

    struct Input {
        var tapNext = PublishSubject<Void>()
        var tapCancel = PublishSubject<Void>()
        var tapBackward = PublishSubject<Void>()
    }

    struct Output {
        var enableNext = PublishSubject<Bool>()
    }

    struct Route {
        var nextProcess = PublishSubject<Void>()
        var backward = PublishSubject<Void>()
        var cancel = PublishSubject<Void>()
    }

    var inputs = Input()
    var outputs = Output()
    var routes = Route()

    // MARK: Private

    private var disposeBag = DisposeBag()
}
