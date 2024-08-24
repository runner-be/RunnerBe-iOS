//
//  DetailSelectPlaceViewModel.swift
//  Runner-be
//
//  Created by 김창규 on 8/23/24.
//

import Foundation
import RxSwift

final class DetailSelectPlaceViewModel: BaseViewModel {
    // MARK: - Properties

    var placeInfo: PlaceInfo

    // MARK: - Init

    init(placeInfo: PlaceInfo) {
        self.placeInfo = placeInfo
    }

    struct Input {}

    struct Output {}

    struct Route {
        var cancel = PublishSubject<Void>()
        var apply = PublishSubject<String>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
