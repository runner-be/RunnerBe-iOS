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
    var daescription: String? = nil
}

final class SelectPlaceViewModel: BaseViewModel {
    // MARK: - Properties

    var completerResults: [MKLocalSearchCompletion]? // 검색한 결과를 담는 변수

    // MARK: - Init

    init(timeString _: String) {
        super.init()

        inputs.completerResults
            .map { [weak self] completerResults in
                self?.completerResults = completerResults
                return completerResults.map {
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
            .compactMap { itemIndex in
                guard let results = self.completerResults,
                      itemIndex < results.count
                else { return nil }
                return results[itemIndex]
            }
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
        var apply = PublishSubject<PlaceInfo>()
        var detailSelectPlace = PublishSubject<MKLocalSearchCompletion>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
