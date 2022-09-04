//
//  ManageAttendanceViewModel.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/04.
//

import Foundation
import RxSwift

final class ManageAttendanceViewModel: BaseViewModel {
    init(myRunningIdx _: Int) {
        super.init()

        inputs.backward
            .bind(to: routes.backward)
            .disposed(by: disposeBag)

        inputs.showExpiredModal
            .bind(to: routes.showExpiredModal)
            .disposed(by: disposeBag)
    }

    struct Input {
        var backward = PublishSubject<Void>()
        var showExpiredModal = PublishSubject<Void>()
    }

    struct Output {
//        var menus = ReplaySubject<[[SettingCellConfig]]>.create(bufferSize: 1)
//        var toast = PublishSubject<String>()
    }

    struct Route {
        var backward = PublishSubject<Void>()
        var showExpiredModal = PublishSubject<Void>()
    }

    struct RouteInputs {
        var showExpiredModal = PublishSubject<Bool>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInputs()
}
