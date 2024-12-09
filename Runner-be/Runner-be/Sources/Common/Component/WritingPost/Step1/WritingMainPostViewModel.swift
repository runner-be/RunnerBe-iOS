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
    var writingPostData: WritingPostData

    init(locationService: LocationService = BasicLocationService.shared) {
        writingPostData = WritingPostData(location: locationService.currentPlace)
        super.init()

        outputs.boundaryLimit.onNext(locationService.allowableBoundary)
        outputs.location.onNext(writingPostData.location)
        outputs.date.onNext(writingPostData.dateString)
        outputs.time.onNext(writingPostData.time)

        inputs.backward
            .debug()
            .bind(to: routes.backward)
            .disposed(by: disposeBag)

        inputs.next
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }

                guard Date().timeIntervalSince1970 < self.writingPostData.date
                else {
                    self.toast.onNext("모임 일시가 이미 지난 시간입니다.")
                    return
                }

                guard !self.writingPostData.time.isEmpty
                else {
                    self.toast.onNext("시간을 다시 설정해 주세요")
                    return
                }
                guard !self.writingPostData.placeName.isEmpty
                else {
                    self.toast.onNext("모임장소를 설정해 주세요")
                    return
                }
                self.routes.next.onNext(self.writingPostData)
            })
            .disposed(by: disposeBag)

        inputs.editTag
            .compactMap { RunningTag(idx: $0) }
            .subscribe(onNext: { [weak self] tag in
                self?.writingPostData.tag = tag.name
            })
            .disposed(by: disposeBag)

        inputs.editTitle
            .filter { text in
                if let text = text,
                   text.count < 31
                {
                    return true
                }
                return false
            }
            .subscribe(onNext: { [weak self] title in
                self?.writingPostData.title = title ?? ""
            })
            .disposed(by: disposeBag)

        inputs.editDate
            .map { [unowned self] in self.writingPostData.date }
            .bind(to: routes.editDate)
            .disposed(by: disposeBag)

        inputs.editTime
            .map { [unowned self] in self.writingPostData.time }
            .bind(to: routes.editTime)
            .disposed(by: disposeBag)

        inputs.editPlace
            .map { [unowned self] in self.writingPostData.time }
            .bind(to: routes.editPlace)
            .disposed(by: disposeBag)

        routeInputs.editDateResult
            .subscribe(onNext: { [weak self] dateInterval in
                guard let self = self else { return }
                self.writingPostData.date = dateInterval
                self.outputs.date.onNext(self.writingPostData.dateString)
            })
            .disposed(by: disposeBag)

        routeInputs.editTimeResult
            .subscribe(onNext: { [weak self] time in
                guard let self = self else { return }
                self.writingPostData.time = time
                self.outputs.time.onNext(time)
            })
            .disposed(by: disposeBag)

        routeInputs.editPlaceResult
            .subscribe(onNext: { [weak self] placeInfo in
                guard let self = self else { return }
                self.writingPostData.placeName = placeInfo.placeName
                self.writingPostData.placeAddress = placeInfo.placeAddress
                self.writingPostData.placeExplain = placeInfo.placeExplain ?? ""
                self.writingPostData.location = placeInfo.location

                self.outputs.placeInfo.onNext((
                    city: placeInfo.placeName,
                    detail: placeInfo.placeExplain ?? ""
                ))
                self.outputs.location.onNext(self.writingPostData.location)
            }).disposed(by: disposeBag)
    }

    struct Input {
        var editTag = PublishSubject<Int>()
        var editTitle = PublishSubject<String?>()
        var editDate = PublishSubject<Void>()
        var editTime = PublishSubject<Void>()
        var editPlace = PublishSubject<Void>()
        var locationChanged = PublishSubject<CLLocationCoordinate2D>()
        var backward = PublishSubject<Void>()
        var next = PublishSubject<Void>()
    }

    struct Output {
        var date = ReplaySubject<String>.create(bufferSize: 1)
        var time = ReplaySubject<String>.create(bufferSize: 1)
        var location = ReplaySubject<CLLocationCoordinate2D>.create(bufferSize: 1)
        var placeInfo = PublishSubject<(city: String, detail: String)>()
        var boundaryLimit = ReplaySubject<[CLLocationCoordinate2D]>.create(bufferSize: 1)
    }

    struct Route {
        var editDate = PublishSubject<Double>()
        var editTime = PublishSubject<String>()
        var editPlace = PublishSubject<String>()
        var backward = PublishSubject<Void>()
        var next = PublishSubject<WritingPostData>()
    }

    struct RouteInput {
        var editDateResult = PublishSubject<Double>()
        var editTimeResult = PublishSubject<String>()
        var editPlaceResult = PublishSubject<PlaceInfo>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
