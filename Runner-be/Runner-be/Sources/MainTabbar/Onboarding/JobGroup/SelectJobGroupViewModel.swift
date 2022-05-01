//
//  SelectJobGroupViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import Foundation
import RxSwift

final class SelectJobGroupViewModel: BaseViewModel {
    var userKeyChainService: UserKeychainService
    var signupService: SignupService

    // MARK: Lifecycle

    init(userKeyChainService: UserKeychainService = BasicUserKeyChainService.shared, signupService: SignupService = BasicSignupService()) {
        self.userKeyChainService = userKeyChainService
        self.signupService = signupService
        super.init()

        inputs.tapCancel
            .bind(to: routes.cancel)
            .disposed(by: disposeBag)

        inputs.tapBackward
            .bind(to: routes.backward)
            .disposed(by: disposeBag)

        inputs.tapComplete
            .flatMap { [unowned self] in
                self.signupService.signup()
            }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success:
                    self?.routes.complete.onNext(())
                case .fail:
                    self?.outputs.toast.onNext("추가정보 입력 중 오류가 발생했습니다.")
                }
            })
            .disposed(by: disposeBag)

        inputs.tapGroup
            .map { selected -> Job in
                guard let idx = selected.first,
                      idx >= 0, idx < Job.allCases.count
                else { return .none }
                return Job.allCases[idx]
            }
            .do(onNext: { [weak self] job in
                self?.userKeyChainService.job = job
            })
            .map { $0 != .none }
            .bind(to: outputs.enableComplete)
            .disposed(by: disposeBag)
    }

    // MARK: Internal

    struct Input {
        var tapComplete = PublishSubject<Void>()
        var tapCancel = PublishSubject<Void>()
        var tapBackward = PublishSubject<Void>()
        var tapGroup = PublishSubject<[Int]>()
    }

    struct Output {
        var enableComplete = PublishSubject<Bool>()
        var toast = PublishSubject<String>()
    }

    struct Route {
        var complete = PublishSubject<Void>()
        var backward = PublishSubject<Void>()
        var cancel = PublishSubject<Void>()
    }

    var inputs = Input()
    var outputs = Output()
    var routes = Route()

    // MARK: Private

    private var disposeBag = DisposeBag()
}
