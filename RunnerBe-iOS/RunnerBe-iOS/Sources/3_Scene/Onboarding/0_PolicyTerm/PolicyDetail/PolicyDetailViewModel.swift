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
    init(policyType: PolicyType, modal: Bool, policyAPIService: PolicyAPIService) {
        super.init()

        policyAPIService.policy(type: policyType)
            .subscribe(outputs.text)
            .disposed(by: disposeBag)

        outputs.modalPresented.onNext(modal)
        outputs.title.onNext(policyType.title)

        inputs.tapClose
            .bind(to: routes.close)
            .disposed(by: disposeBag)
    }

    struct Input {
        var tapClose = PublishSubject<Void>()
    }

    struct Output {
        var modalPresented = ReplaySubject<Bool>.create(bufferSize: 1)
        var title = ReplaySubject<String>.create(bufferSize: 1)
        var text = ReplaySubject<String>.create(bufferSize: 1)
    }

    struct Route {
        var close = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
