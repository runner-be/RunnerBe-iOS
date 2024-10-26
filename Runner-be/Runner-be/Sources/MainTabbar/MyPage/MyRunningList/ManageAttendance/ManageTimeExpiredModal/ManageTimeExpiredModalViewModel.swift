//
//  ManageTimeExpiredModalViewModel.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/23.
//

import Foundation
import RxSwift

final class ManageTimeExpiredModalViewModel: BaseViewModel {
    override init() {
        super.init()

        inputs.tapOK
            .bind(to: routes.ok)
            .disposed(by: disposeBag)
    }

    struct Input {
        var tapOK = PublishSubject<Void>()
        var backward = PublishSubject<Void>()
    }

    struct Output {}
    struct Route {
        var ok = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
