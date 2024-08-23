//
//  SelectPlaceViewModel.swift
//  Runner-be
//
//  Created by 김창규 on 8/20/24.
//

import Foundation
import MapKit
import RxSwift

struct PlaceInfo {
    let title: String
    let subTitle: String
}

final class SelectPlaceViewModel: BaseViewModel {
    // MARK: - Init

    init(timeString _: String) {
        super.init()

        inputs.completerResults
            .map {
                $0.map {
                    SelectPlaceResultCellConfig(
                        from: PlaceInfo(
                            title: $0.title,
                            subTitle: $0.subtitle
                        )
                    )
                }
            }
            .bind(to: outputs.placeList)
            .disposed(by: disposeBag)

        inputs.tapPlace
            .bind(to: routes.detailSelectPlace)
            .disposed(by: disposeBag)
    }

    struct Input {
        var completerResults = PublishSubject<[MKLocalSearchCompletion]>()
        var tapPlace = PublishSubject<Int>()
    }

    struct Output {
        var placeList = ReplaySubject<[SelectPlaceResultCellConfig]>.create(bufferSize: 1)
    }

    struct Route {
        var cancel = PublishSubject<Void>()
        var apply = PublishSubject<String>()
        var detailSelectPlace = PublishSubject<Int>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
