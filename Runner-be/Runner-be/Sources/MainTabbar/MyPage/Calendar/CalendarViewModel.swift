//
//  CalendarViewModel.swift
//  Runner-be
//
//  Created by 김창규 on 8/27/24.
//

import Foundation
import RxSwift

final class CalendarViewModel: BaseViewModel {
    override init() {
        super.init()
        let items = [
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 1)),
        ]

        let test = [
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 1)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 2)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 3)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 4)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 5)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 6)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 7)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 8)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 9)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 10)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 11)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 12)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 13)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 14)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 15)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 16)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 17)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 18)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 19)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 20)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 21)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 22)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 23)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 24)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 25)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 26)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 27)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 28)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 29)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 30)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 31)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 32)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 33)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 34)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 35)),
        ]

        outputs.days.onNext(test)
    }

    struct Input {}

    struct Output {
        var days = ReplaySubject<[MyLogStampConfig]>.create(bufferSize: 1)
    }

    struct Route {
        var backward = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
