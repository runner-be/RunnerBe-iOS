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

        inputs.backward
            .debug()
            .bind(to: routes.backward)
            .disposed(by: disposeBag)

        inputs.next
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }

                guard !self.writingPostData.title.isEmpty
                else {
                    self.outputs.toast.onNext("제목을 입력해주세요")
                    return
                }

                guard Date().timeIntervalSince1970 < self.writingPostData.date
                else {
                    self.outputs.toast.onNext("모임 일시가 이미 지난 시간입니다.")
                    return
                }

                guard !self.writingPostData.time.isEmpty
                else {
                    self.outputs.toast.onNext("시간을 다시 설정해 주세요")
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
            .subscribe(onNext: { [weak self] title in
                self?.writingPostData.title = title
            })
            .disposed(by: disposeBag)

        inputs.editDate
            .bind(to: routes.editDate)
            .disposed(by: disposeBag)

        inputs.editTime
            .bind(to: routes.editTime)
            .disposed(by: disposeBag)

        inputs.locationChanged
            .subscribe(onNext: { [weak self] location in
                self?.writingPostData.location = location
            })
            .disposed(by: disposeBag)

        inputs.locationChanged
            .map { coord in
                locationService.geoCodeLocation(at: coord)
            }
            .compactMap { $0 }
            .flatMap { $0 }
            .map { placeInfo -> (city: String, detail: String) in
                guard let info = placeInfo else { return ("", "") }
                let city = info.locality ?? ""
                let locality = info.subLocality ?? ""
                let name = info.name ?? ""
                return (city: city + " " + locality, detail: name)
            }
            .subscribe(onNext: { [weak self] placeInfo in
                self?.writingPostData.placeInfo = placeInfo.detail
                self?.outputs.placeInfo.onNext(placeInfo)
            })
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
    }

    struct Input {
        var editTag = PublishSubject<Int>()
        var editTitle = PublishSubject<String>()
        var editDate = PublishSubject<Void>()
        var editTime = PublishSubject<Void>()
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
        var toast = PublishSubject<String>()
    }

    struct Route {
        var editDate = PublishSubject<Void>()
        var editTime = PublishSubject<Void>()
        var backward = PublishSubject<Void>()
        var next = PublishSubject<WritingPostData>()
    }

    struct RouteInput {
        var editDateResult = PublishSubject<Double>()
        var editTimeResult = PublishSubject<String>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
