//
//  BirthViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/07.
//

import Foundation
import RxSwift

final class BirthViewModel: BaseViewModel {
    // MARK: Lifecycle

    override init() {
        super.init()

        // TODO: DateFormatter DI
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let yearString = dateFormatter.string(from: today)
        let thisYear = Int(yearString) ?? 2020

        ((thisYear - 80) ... thisYear).reversed()
            .forEach { self.outputs.items.append($0) }

        inputs.itemSelected
            .filter { $0 < 81 && $0 > 0 }
            .map { $0 > 19 }
            .subscribe(outputs.enableNext)
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
