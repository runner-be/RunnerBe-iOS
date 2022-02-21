//
//  WritingMainPostViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/18.
//

import CoreLocation
import Foundation
import RxSwift

final class WritingMainPostViewModel: BaseViewModel {
    private var locationService: LocationService

    init(locationService: LocationService) {
        self.locationService = locationService
        super.init()

        if let currentLocation = locationService.currentPlace {
            outputs.location.onNext(currentLocation)
        }

        inputs.backward
            .debug()
            .bind(to: routes.backward)
            .disposed(by: disposeBag)

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
        var backward = PublishSubject<Void>()
    }

    struct Output {
        var date = PublishSubject<String>()
        var time = PublishSubject<String>()
        var location = ReplaySubject<CLLocationCoordinate2D>.create(bufferSize: 1)
    }

    struct Route {
        var editDate = PublishSubject<Void>()
        var editTime = PublishSubject<Void>()
        var backward = PublishSubject<Void>()
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
