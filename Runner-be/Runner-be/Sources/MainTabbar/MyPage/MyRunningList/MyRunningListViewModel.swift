//
//  MyRunningListViewModel.swift
//  Runner-be
//
//  Created by 김창규 on 8/29/24.
//

import Foundation
import RxSwift

final class MyRunningListViewModel: BaseViewModel {
    // MARK: - Properties

    // MARK: - Init

    override init() {
        super.init()
    }

    // MARK: - Methods

    struct Input {}

    struct Output {}

    struct Route {
        var backward = PublishSubject<Void>()
    }

    struct RouteInput {}

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
