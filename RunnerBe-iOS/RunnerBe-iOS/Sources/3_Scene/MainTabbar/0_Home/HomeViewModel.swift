//
//  HomeViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import RxSwift

final class HomeViewModel: BaseViewModel {
    private var locationService: LocationService

    init(locationService: LocationService) {
        self.locationService = locationService
        super.init()

        inputs.filter
            .bind(to: routes.filter)
            .disposed(by: disposeBag)

        inputs.writingPost
            .bind(to: routes.writingPost)
            .disposed(by: disposeBag)
    }

    struct Input {
        var filter = PublishSubject<Void>()
        var writingPost = PublishSubject<Void>()
    }

    struct Output {}

    struct Route {
        var filter = PublishSubject<Void>()
        var writingPost = PublishSubject<Void>()
    }

    var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
