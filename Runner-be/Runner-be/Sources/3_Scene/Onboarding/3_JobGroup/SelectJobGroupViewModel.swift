//
//  SelectJobGroupViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import Foundation
import RxSwift

final class SelectJobGroupViewModel: BaseViewModel {
    var signupKeyChainService: SignupKeyChainService

    // MARK: Lifecycle

    init(signupKeyChainService: SignupKeyChainService = BasicSignupKeyChainService.shared) {
        self.signupKeyChainService = signupKeyChainService
        super.init()

        inputs.tapCancel
            .bind(to: routes.cancel)
            .disposed(by: disposeBag)

        inputs.tapBackward
            .bind(to: routes.backward)
            .disposed(by: disposeBag)

        inputs.tapNext
            .subscribe(routes.nextProcess)
            .disposed(by: disposeBag)

        inputs.tapGroup
            .map { selected -> Job in
                guard let idx = selected.first,
                      idx >= 0, idx < Job.allCases.count
                else { return .none }
                return Job.allCases[idx]
            }
            .do(onNext: { [weak self] job in
                self?.signupKeyChainService.job = job
            })
            .map { $0 != .none }
            .bind(to: outputs.enableNext)
            .disposed(by: disposeBag)
    }

    // MARK: Internal

    struct Input {
        var tapNext = PublishSubject<Void>()
        var tapCancel = PublishSubject<Void>()
        var tapBackward = PublishSubject<Void>()
        var tapGroup = PublishSubject<[Int]>()
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
