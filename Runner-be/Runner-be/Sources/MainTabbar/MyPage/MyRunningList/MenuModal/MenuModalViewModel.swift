//
//  MenuModalViewModel.swift
//  Runner-be
//
//  Created by 김창규 on 9/6/24.
//

import Foundation
import RxSwift

final class MenuModalViewModel: BaseViewModel {
    // MARK: - Properties

    struct Input {
        var tapBackground = PublishSubject<Void>()
        var tapEdit = PublishSubject<Void>()
        var tapDelete = PublishSubject<Void>()
    }

    struct Output {}

    struct Route {
        var backward = PublishSubject<Void>()
        var writeLog = PublishSubject<Void>()
    }

    struct RouteInputs {
        var deletedLog = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInputs()

    // MARK: - Init

    init(logAPIService _: LogAPIService = BasicLogAPIService()) {
        super.init()

        inputs.tapBackground
            .bind(to: routes.backward)
            .disposed(by: disposeBag)

        inputs.tapEdit
            .bind(to: routes.writeLog)
            .disposed(by: disposeBag)

        inputs.tapDelete
            .bind(to: routeInputs.deletedLog)
            .disposed(by: disposeBag)
    }

    // MARK: - Methods
}
