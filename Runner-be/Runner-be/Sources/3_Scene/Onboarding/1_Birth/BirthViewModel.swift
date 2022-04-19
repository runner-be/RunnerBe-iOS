//
//  BirthViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/07.
//

import Foundation
import RxSwift

final class BirthViewModel: BaseViewModel {
    private var userKeyChainService: UserKeychainService

    // MARK: Lifecycle

    init(userKeyChainService: UserKeychainService = BasicUserKeyChainService.shared) {
        self.userKeyChainService = userKeyChainService
        super.init()

        let thisYear = Int(DateUtil.shared.getCurrent(format: .yyyy)) ?? DateUtil.shared.defaultYear

        ((thisYear - 80) ... thisYear).reversed()
            .forEach { self.outputs.items.append($0) }

        inputs.itemSelected
            .filter { $0 < 81 && $0 > 0 }
            .map { $0 > 19 }
            .subscribe(outputs.enableNext)
            .disposed(by: disposeBag)

        inputs.tapNext
            .do(onNext: { [weak self] in
                guard let self = self else { return }
                let idx = try! self.inputs.itemSelected.value()
                let year = self.outputs.items[idx]
                self.userKeyChainService.birthDay = year
            })
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
        var itemSelected = BehaviorSubject<Int>(value: 0)

        var tapNext = PublishSubject<Void>()
        var tapCancel = PublishSubject<Void>()
        var tapBackward = PublishSubject<Void>()
    }

    struct Output {
        var enableNext = PublishSubject<Bool>()
        var items = [Int]()
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
