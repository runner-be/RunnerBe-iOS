//
//  SelectJobGroupViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import Foundation
import RxSwift

final class SelectJobGroupViewModel: BaseViewModel {
    // MARK: Lifecycle

    override init() {
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
            .map { $0.isEmpty == false }
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
