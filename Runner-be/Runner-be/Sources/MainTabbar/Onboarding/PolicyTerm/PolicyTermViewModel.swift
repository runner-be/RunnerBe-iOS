//
//  PolicyTermViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/07.
//

import Foundation
import RxSwift

final class PolicyTermViewModel: BaseViewModel {
    // MARK: Lifecycle

    override init() {
        super.init()

        Observable<Bool>.combineLatest(
            inputs.tapServicePolicy,
            inputs.tapPrivacyPolicy,
            inputs.tapLocationPolicy
        ) { service, privacy, location in
            service && privacy && location
        }
        .subscribe(outputs.enableNext)
        .disposed(by: disposeBag)

        inputs.tapServiceDetail
            .map { PolicyType.service }
            .subscribe(routes.showPolicy)
            .disposed(by: disposeBag)

        inputs.tapPrivacyDetail
            .map { PolicyType.privacy_collect }
            .subscribe(routes.showPolicy)
            .disposed(by: disposeBag)

        inputs.tapLocationDetail
            .map { PolicyType.location }
            .subscribe(routes.showPolicy)
            .disposed(by: disposeBag)

        inputs.tapNext
            .subscribe(routes.nextProcess)
            .disposed(by: disposeBag)

        inputs.tapCancel
            .subscribe(routes.cancel)
            .disposed(by: disposeBag)

        inputs.tapBackward
            .subscribe(routes.backward)
            .disposed(by: disposeBag)
    }

    // MARK: Internal

    struct Input {
        var tapNext = PublishSubject<Void>()
        var tapCancel = PublishSubject<Void>()
        var tapBackward = PublishSubject<Void>()

        var tapServicePolicy = BehaviorSubject<Bool>(value: false)
        var tapPrivacyPolicy = BehaviorSubject<Bool>(value: false)
        var tapLocationPolicy = BehaviorSubject<Bool>(value: false)

        var tapServiceDetail = PublishSubject<Void>()
        var tapPrivacyDetail = PublishSubject<Void>()
        var tapLocationDetail = PublishSubject<Void>()
    }

    struct Output {
        var enableNext = PublishSubject<Bool>()
    }

    struct Route {
        var showPolicy = PublishSubject<PolicyType>()
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
