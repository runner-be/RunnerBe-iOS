//
//  HomeFilterViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/16.
//

import CoreLocation
import Foundation
import RxSwift

final class HomeFilterViewModel: BaseViewModel {
    private var locationService: LocationService

    init(locationService: LocationService) {
        self.locationService = locationService
        super.init()

        outputs.boundaryLimit.onNext(locationService.allowableBoundary)
        if let currentLocation = locationService.currentPlace {
            outputs.location.onNext(currentLocation)
        }

        inputs.backward
            .debug()
            .bind(to: routes.backward)
            .disposed(by: disposeBag)
    }

    struct Input {
        var backward = PublishSubject<Void>()
    }

    struct Output {
        var location = ReplaySubject<CLLocationCoordinate2D>.create(bufferSize: 1)
        var boundaryLimit = ReplaySubject<[CLLocationCoordinate2D]>.create(bufferSize: 1)
    }

    struct Route {
        var backward = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
