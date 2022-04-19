//
//  SelectGenderViewModel.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import Foundation
import RxSwift

final class SelectGenderViewModel: BaseViewModel {
    var userKeyChainService: UserKeychainService

    // MARK: Lifecycle

    init(userKeyChainService: UserKeychainService = BasicUserKeyChainService.shared) {
        self.userKeyChainService = userKeyChainService
        super.init()

        inputs.tapCancel
            .subscribe(routes.cancel)
            .disposed(by: disposeBag)

        inputs.tapBackward
            .subscribe(routes.backward)
            .disposed(by: disposeBag)

        inputs.tapNext
            .subscribe(routes.nextProcess)
            .disposed(by: disposeBag)

        inputs.tapGroup
            .map { selected -> Gender in
                if let idx = selected.first,
                   idx < 2, idx >= 0
                {
                    return idx == 0 ? .female : .male
                }
                return .none
            }
            .do(onNext: { [weak self] gender in
                self?.userKeyChainService.gender = gender
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
