//
//  MessageViewModel.swift
//  Runner-be
//
//  Created by 김신우 on 2022/04/26.
//

import Foundation
import RxSwift

final class MessageViewModel: BaseViewModel {
    override init() {
        super.init()
    }

    struct Input {}

    struct Output {}

    struct Route {}

    struct RouteInput {
        let needsUpdate = PublishSubject<Bool>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
