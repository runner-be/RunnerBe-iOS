//
//  LogModalViewModel.swift
//  Runner-be
//
//  Created by 김창규 on 9/6/24.
//

import Foundation

import Foundation
import RxSwift

final class LogModalViewModel: BaseViewModel {
    // MARK: - Properties

    struct Input {}

    struct Output {}

    struct Route {
        var backward = PublishSubject<Void>()
        var tapOK = PublishSubject<Void>()
    }

    struct RouteInputs {}

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInputs()

    // MARK: - Init

    override init() {
        super.init()
    }

    // MARK: - Methods
}
