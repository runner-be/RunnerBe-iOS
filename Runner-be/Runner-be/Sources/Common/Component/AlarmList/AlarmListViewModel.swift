//
//  AlarmListViewModel.swift
//  Runner-be
//
//  Created by 김신우 on 2022/08/21.
//

import Foundation
import RxSwift

final class AlarmListViewModel: BaseViewModel {
    var alarms: [Alarm] = []

    init(userAPIService: UserAPIService = BasicUserAPIService()) {
        super.init()

        userAPIService.fetchAlarms()
            .subscribe(onNext: { [weak self] alarms in
                if let alarms = alarms {
                    let sorted = alarms.sorted(by: { $0.createdAt > $1.createdAt })
                    self?.alarms = sorted
                    self?.outputs.alarmList.onNext(sorted)
                }
            })
            .disposed(by: disposeBag)

        inputs.backward
            .bind(to: routes.backward)
            .disposed(by: disposeBag)

        inputs.alarmChecked
            .subscribe(onNext: { [weak self] item in
                guard let self = self,
                      self.alarms[item].isNew
                else { return }
                
                self.alarms[item].isNew = false
                self.outputs.alarmList.onNext(self.alarms)
            })
            .disposed(by: disposeBag)
    }

    struct Input {
        var backward = PublishSubject<Void>()
        var alarmChecked = PublishSubject<Int>()
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
