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
    private let locationUseCase = LocationUseCase.shared
    private var inputFilter: PostFilter

    typealias InputData = (
        genderIdx: Int?,
        jobIdx: Int?,
        minAge: Int, maxAge: Int
    )

    init(inputFilter: PostFilter) {
        self.inputFilter = inputFilter
        super.init()

        uiBusinessLogic()
        requestDataToRepo()
    }

    // MARK: - INPUT, OUTPUT Modeling

    struct Input {
        var backward = PublishSubject<InputData?>()
        var reset = PublishSubject<Void>()
    }

    struct Output {
        var locationDistance = ReplaySubject<(location: CLLocationCoordinate2D, distance: Float)>.create(bufferSize: 1)
        var boundaryLimit = ReplaySubject<[CLLocationCoordinate2D]>.create(bufferSize: 1)
        var gender = ReplaySubject<Int>.create(bufferSize: 1)
        var job = ReplaySubject<Int>.create(bufferSize: 1)
        var age = ReplaySubject<(min: Int, max: Int)>.create(bufferSize: 1)
        var reset = PublishSubject<Void>()
    }

    struct Route {
        var backward = PublishSubject<PostFilter>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}

// MARK: - Repository와 소통

extension HomeFilterViewModel {
    func requestDataToRepo() {
        inputs.reset
            .subscribe(onNext: {
                self.outputs.locationDistance.onNext((location: self.locationUseCase.currentPlace, distance: 3000))
                self.outputs.reset.onNext(())
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UI 관련 비즈니스 로직

extension HomeFilterViewModel {
    func uiBusinessLogic() {
        outputs.locationDistance.onNext(
            (
                location: CLLocationCoordinate2D(
                    latitude: inputFilter.latitude,
                    longitude: inputFilter.longitude
                ),
                distance: inputFilter.distanceFilter * 1000
            )
        )

        outputs.age.onNext((min: inputFilter.ageMin, max: inputFilter.ageMax))
        outputs.job.onNext(inputFilter.jobFilter.index)
        outputs.gender.onNext(inputFilter.gender.index)

        inputs.backward
            .map { input in
                guard let input = input
                else {
                    return PostFilter(
                        latitude: 0,
                        longitude: 0,
                        postState: .error,
                        filter: .error,
                        distanceFilter: 10,
                        gender: .none,
                        ageMin: 20, ageMax: 65,
                        runningTag: .error,
                        jobFilter: .none,
                        keywordSearch: "N"
                    )
                }
                let gender = Gender(idx: input.genderIdx ?? -1)
                let job = Job(idx: input.jobIdx ?? -1)
                return PostFilter(
                    latitude: 0,
                    longitude: 0,
                    postState: .error, filter: .error,
                    distanceFilter: 0,
                    gender: gender,
                    ageMin: input.minAge,
                    ageMax: input.maxAge,
                    runningTag: .error,
                    jobFilter: job,
                    keywordSearch: "N"
                )
            }
            .bind(to: routes.backward)
            .disposed(by: disposeBag)
    }
}
