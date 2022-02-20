//
//  WritingMainPostViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/18.
//

import Foundation
import RxSwift

final class WritingMainPostViewModel: BaseViewModel {
    override init() {
        super.init()

        inputs.editDate
            .bind(to: routes.editDate)
            .disposed(by: disposeBag)

        inputs.editTime
            .bind(to: routes.editTime)
            .disposed(by: disposeBag)

        routeInputs.editDateResult
            .bind(to: outputs.date)
            .disposed(by: disposeBag)

        routeInputs.editTimeResult
            .bind(to: outputs.time)
            .disposed(by: disposeBag)
    }

    struct Input {
        var editDate = PublishSubject<Void>()
        var editTime = PublishSubject<Void>()
    }

    struct Output {
        var date = PublishSubject<String>()
        var time = PublishSubject<String>()
    }

    struct Route {
        var editDate = PublishSubject<Void>()
        var editTime = PublishSubject<Void>()
    }

    struct RouteInput {
        var editDateResult = PublishSubject<String>()
        var editTimeResult = PublishSubject<String>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
