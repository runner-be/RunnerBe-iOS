//
//  PolicyDetailViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import Foundation
import RxRelay
import RxSwift

final class PolicyDetailViewModel: BaseViewModel {
    init(policyType: PolicyType) {
        let text: String
        switch policyType {
        case .service:
            text = "service"
        case .privacy:
            text = "privacy"
        case .location:
            text = "location"
        }

        outputs = Output(text: BehaviorSubject<String>(value: text))
        super.init()

        inputs.tapClose
            .bind(to: routes.close)
            .disposed(by: disposeBag)
    }

    struct Input {
        var tapClose = PublishSubject<Void>()
    }

    struct Output {
        var text: BehaviorSubject<String>
    }

    struct Route {
        var close = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs: Output
    var routes = Route()
}
