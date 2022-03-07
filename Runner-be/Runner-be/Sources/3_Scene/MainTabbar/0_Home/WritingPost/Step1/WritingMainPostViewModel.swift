//
//  WritingMainPostViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/18.
//

import CoreLocation
import Foundation
import RxSwift

struct WritingPostMainViewInputData {
    let tag: Int
    let title: String
    let date: String
    let time: String
    let location: CLLocationCoordinate2D
    let placeInfo: String
}

final class WritingMainPostViewModel: BaseViewModel {
    private var locationService: LocationService

    init(locationService: LocationService) {
        self.locationService = locationService
        super.init()

        outputs.boundaryLimit.onNext(locationService.allowableBoundary)
        if let currentLocation = locationService.currentPlace {
            outputs.location.onNext(currentLocation)
        }

        let curDate = Date()
        let datePlaceHolder =
            DateUtil.shared.formattedString(for: curDate, format: .custom(format: "M/d (E)"))
                + " "
                + DateUtil.shared.formattedString(for: curDate, format: .ampm, localeId: "en_US")
                + " "
                + DateUtil.shared.formattedString(for: curDate, format: .custom(format: "H:mm"))
        outputs.date.onNext(datePlaceHolder)

        inputs.backward
            .debug()
            .bind(to: routes.backward)
            .disposed(by: disposeBag)

        inputs.next
            .compactMap { [weak self] inputData in
                if inputData == nil {
                    self?.outputs.toast.onNext("데이터 처리에 실패하였습니다.")
                    return nil
                }

                if inputData!.title.isEmpty {
                    self?.outputs.toast.onNext("제목을 입력해주세요")
                    return nil
                }

                if inputData!.date.isEmpty {
                    self?.outputs.toast.onNext("일시를 입력해주세요")
                    return nil
                }
                let selectedDate = DateUtil.shared.getCurrent(format: .yyyy) + " " + inputData!.date
                // TODO: 12월 ~ 1월 대응해야됨!
                if let date = DateUtil.shared.getDate(from: selectedDate, format: .posting) {
                    if Date() > date {
                        self?.outputs.toast.onNext("이미 지난 날짜 입니다.")
                        return nil
                    }
                } else {
                    self?.outputs.toast.onNext("날짜 형식이 올바르지 않습니다.")
                    return nil
                }

                if inputData!.time.isEmpty {
                    self?.outputs.toast.onNext("소요시간을 입력해주세요")
                    return nil
                }

                return inputData!
            }
            .map { (inputData: WritingPostMainViewInputData) -> WritingPostDetailConfigData in
                WritingPostDetailConfigData(
                    tag: RunningTag.allCases[inputData.tag].name,
                    title: inputData.title,
                    date: inputData.date,
                    time: inputData.time,
                    location: inputData.location,
                    placeInfo: inputData.placeInfo
                )
            }
            .bind(to: routes.next)
            .disposed(by: disposeBag)

        inputs.editDate
            .bind(to: routes.editDate)
            .disposed(by: disposeBag)

        inputs.editTime
            .bind(to: routes.editTime)
            .disposed(by: disposeBag)

        inputs.locationChanged
            .map { [weak self] coord in
                self?.locationService.geoCodeLocation(at: coord)
            }
            .compactMap { $0 }
            .flatMap { $0 }
            .map { placeInfo -> (first: String, second: String) in
                guard let info = placeInfo else { return ("", "") }
                let city = info.administrativeArea ?? ""
                let locality = info.locality ?? ""
                let name = info.name ?? ""
                return (city + " " + locality, name)
            }
            .subscribe(outputs.placeInfo)
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
        var next = PublishSubject<WritingPostMainViewInputData?>()
        var locationChanged = PublishSubject<CLLocationCoordinate2D>()
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
        var next = PublishSubject<WritingPostDetailConfigData>()
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
