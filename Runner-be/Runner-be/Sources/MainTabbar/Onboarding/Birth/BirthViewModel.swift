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

        let thisYear = Int(DateUtil.shared.getCurrent(format: .yyyy))!

        ((thisYear - 80) ... thisYear).reversed()
            .forEach { self.outputs.items.append($0) }

        inputs.itemSelected
            .map { $0 >= 19 }
            .subscribe(outputs.enableNext)
            .disposed(by: disposeBag)

        inputs.tapNext
            .map { [unowned self] in
                guard let idx = try? self.inputs.itemSelected.value()
                else { return -1 }
                return idx
            }
            .do(onNext: { [unowned self] idx in
                if idx < 19 {
                    self.toast.onNext("19세 이상만 진행 가능합니다.")
                } else {
                    self.userKeyChainService.birthDay = self.outputs.items[idx]
                }
            })
            .filter { $0 > 19 }
            .map { _ in }
            .subscribe(routes.nextProcess)
            .disposed(by: disposeBag)

        inputs.tapCancel
            .subscribe(routes.cancel)
            .disposed(by: disposeBag)

        inputs.tapBackward
            .subscribe(routes.backward)
            .disposed(by: disposeBag)

        routeInputs.returned
            .subscribe(onNext: { [weak self] in
                guard let self = self,
                      let idx = try? self.inputs.itemSelected.value()
                else { return }
                let year = self.outputs.items[idx]
                if idx < 19 {
                    self.outputs.enableNext.onNext(false)
                }
            })
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

    struct RouteInput {
        var returned = PublishSubject<Void>()
    }

    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()

    // MARK: Private

    private var disposeBag = DisposeBag()
}
