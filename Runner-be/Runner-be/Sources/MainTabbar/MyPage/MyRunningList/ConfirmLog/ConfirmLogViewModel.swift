//
//  ConfirmLogViewModel.swift
//  Runner-be
//
//  Created by 김창규 on 8/30/24.
//

import RxSwift

final class ConfirmLogViewModel: BaseViewModel {
    // MARK: - Properties

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()

    // MARK: - Init

    init(postId _: Int) {}

    // MARK: - Methods

    struct Input {}

    struct Output {}

    struct Route {
        var backward = PublishSubject<Bool>()
    }

    struct RouteInput {}
}
