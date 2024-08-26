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
    let locationInfo: String // 위치 이름(거리, 상호, 장소명)
    let placeName: String // 위치 주소
    var placeExplain: String? = nil
    var location: CLLocationCoordinate2D // 위도, 경도
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
                            locationInfo: $0.title,
                            placeName: $0.subtitle,
                            location: CLLocationCoordinate2D()
                        )
                    )
                }
            }
            .bind(to: outputs.placeList)
            .disposed(by: disposeBag)

        inputs.tapPlace
            .compactMap { itemIndex -> MKLocalSearchCompletion? in
                guard let results = self.completerResults,
                      itemIndex < results.count
                else {
                    return nil
                }
                return results[itemIndex]
            }
            .bind { [weak self] completerResult in
                guard let self = self else { return }
                self.fetchLocation(for: completerResult)
            }
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
        var detailSelectPlace = PublishSubject<PlaceInfo>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()

    // MARK: - Methods

    private func fetchLocation(for completion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = completion.title + " " + completion.subtitle

        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let mapItem = response?.mapItems.first, error == nil else {
                return
            }
            self.routes.detailSelectPlace.onNext(PlaceInfo(
                locationInfo: completion.title,
                placeName: completion.subtitle,
                location: mapItem.placemark.coordinate
            ))
        }
    }
}
