//
//  SelectPlaceViewModel.swift
//  Runner-be
//
//  Created by 김창규 on 8/20/24.
//

import Foundation
import RxSwift

struct PlaceInfo {
    let title: String
    let subTitle: String
}

final class SelectPlaceViewModel: BaseViewModel {
    init(timeString _: String) {
        super.init()

        // example
        let test = [
            SelectPlaceResultCellConfig(from: PlaceInfo(
                title: "여의도 공원",
                subTitle: "서울 영등포구 여의도동 2"
            )),
            SelectPlaceResultCellConfig(from: PlaceInfo(
                title: "여의도공원인라인대여소",
                subTitle: "서울 영등포구 여의공원로 68"
            )),
            SelectPlaceResultCellConfig(from: PlaceInfo(
                title: "씨유소나무 공원점",
                subTitle: "서울 영등포구 여의도동 77"
            )),
            SelectPlaceResultCellConfig(from: PlaceInfo(
                title: "여의도 라운지",
                subTitle: "서울 영등포구 여의도동 222"
            )),
            SelectPlaceResultCellConfig(from: PlaceInfo(
                title: "여의도 라운지",
                subTitle: "서울 영등포구 여의도동 222"
            )),
            SelectPlaceResultCellConfig(from: PlaceInfo(
                title: "여의도 키즈 카페",
                subTitle: "서울 영등포구 여의도동 231"
            )),
            SelectPlaceResultCellConfig(from: PlaceInfo(
                title: "여의도 공원",
                subTitle: "서울 영등포구 여의도동 2"
            )),
            SelectPlaceResultCellConfig(from: PlaceInfo(
                title: "여의도공원인라인대여소",
                subTitle: "서울 영등포구 여의공원로 68"
            )),
            SelectPlaceResultCellConfig(from: PlaceInfo(
                title: "씨유소나무 공원점",
                subTitle: "서울 영등포구 여의도동 77"
            )),
            SelectPlaceResultCellConfig(from: PlaceInfo(
                title: "여의도 라운지",
                subTitle: "서울 영등포구 여의도동 222"
            )),
            SelectPlaceResultCellConfig(from: PlaceInfo(
                title: "여의도 라운지",
                subTitle: "서울 영등포구 여의도동 222"
            )),
            SelectPlaceResultCellConfig(from: PlaceInfo(
                title: "여의도 키즈 카페",
                subTitle: "서울 영등포구 여의도동 231"
            )),
        ]

        outputs.placeList.onNext(test)
    }

    struct Input {}

    struct Output {
        var placeList = ReplaySubject<[SelectPlaceResultCellConfig]>.create(bufferSize: 1)
    }

    struct Route {
        var cancel = PublishSubject<Void>()
        var apply = PublishSubject<String>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
