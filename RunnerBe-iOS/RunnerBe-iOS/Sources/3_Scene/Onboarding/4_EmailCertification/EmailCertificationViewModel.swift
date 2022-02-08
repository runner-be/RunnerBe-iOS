//
//  EmailCertificationViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import Foundation
import RxSwift

final class EmailCertificationViewModel {
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
