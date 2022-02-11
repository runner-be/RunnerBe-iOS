//
//  EmailCertificationViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import Foundation
import RxSwift

final class EmailCertificationViewModel: BaseViewModel {
    override init() {
        super.init()

        inputs.tapCancel
            .subscribe(routes.cancel)
            .disposed(by: disposeBag)

        inputs.tapBackward
            .subscribe(routes.backward)
            .disposed(by: disposeBag)

        inputs.tapNoEmail
            .subscribe(routes.photoCertification)
            .disposed(by: disposeBag)

        inputs.emailText
            .map { $0?.count ?? 0 }
            .map { $0 != 0 }
            .bind(to: outputs.enableNext)
            .disposed(by: disposeBag)
    }

    // MARK: Internal

    struct Input {
        var tapNoEmail = PublishSubject<Void>()
        var tapCancel = PublishSubject<Void>()
        var tapBackward = PublishSubject<Void>()

        var emailText = PublishSubject<String?>()
    }

    struct Output {
        var enableNext = PublishSubject<Bool>()
    }

    struct Route {
        var photoCertification = PublishSubject<Void>()
        var backward = PublishSubject<Void>()
        var cancel = PublishSubject<Void>()
    }

    var inputs = Input()
    var outputs = Output()
    var routes = Route()

    // MARK: Private

    private var disposeBag = DisposeBag()
}
