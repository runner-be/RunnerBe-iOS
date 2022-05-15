//
//  MessageDeleteComponent.swift
//  Runner-be
//
//  Created by 이유리 on 2022/05/07.
//

import Foundation
import RxSwift

final class MessageDeleteViewModel: BaseViewModel {
    override init() {
        super.init()
    }

    struct Input {}

    struct Output {}

    struct Route {
        var backward = PublishSubject<Void>()
    }

    struct RouteInput {
        let needsUpdate = PublishSubject<Bool>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
