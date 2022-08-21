//
//  AlarmListViewModel.swift
//  Runner-be
//
//  Created by 김신우 on 2022/08/21.
//

import Foundation
import RxSwift

final class AlarmListViewModel: BaseViewModel {
    override init() {
        super.init()

        inputs.backward
            .bind(to: routes.backward)
            .disposed(by: disposeBag)
    }

    struct Input {
        var backward = PublishSubject<Void>()
    }

    struct Output {
        var alarmList = PublishSubject<[Alarm]>()
    }

    struct Route {
        var backward = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
