//
//  LicenseViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/02.
//
import Foundation
import RxSwift

final class LicenseViewModel: BaseViewModel {
    override init() {
        super.init()

        inputs.backward
            .bind(to: routes.backward)
            .disposed(by: disposeBag)
    }

    struct Input {
        var backward = PublishSubject<Void>()
    }

    struct Output {}

    struct Route {
        var backward = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
