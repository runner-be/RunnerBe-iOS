//
//  WaitCertificationViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import Foundation
import RxSwift

final class WaitCertificationViewModel: BaseViewModel {
    override init() {
        super.init()

        inputs.tapToMain
            .map { false }
            .subscribe(routes.toMain)
            .disposed(by: disposeBag)
    }

    struct Input {
        let tapToMain = PublishSubject<Void>()
    }

    struct Output {}
    struct Route {
        let toMain = PublishSubject<Bool>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
