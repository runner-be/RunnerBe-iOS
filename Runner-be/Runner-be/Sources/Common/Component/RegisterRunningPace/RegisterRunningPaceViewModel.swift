//
//  RegisterRunningPaceViewModel.swift
//  Runner-be
//
//  Created by 이유리 on 2/12/24.
//

import Foundation
import RxSwift

final class RegisterRunningPaceViewModel: BaseViewModel {
    var runningPace: String = ""

    init(userAPIService: UserAPIService = BasicUserAPIService()) {
        super.init()

        inputs.close
            .bind(to: routes.showCancelModal)
            .disposed(by: disposeBag)

        inputs.registerRunningPace
            .do(onNext: {
                self.runningPace = $0
            })
            .flatMap { userAPIService.patchRunningPace(pace: $0) }
            .subscribe(onNext: { isPatchRunningPaceCompleted in
                if isPatchRunningPaceCompleted {
                    BasicUserKeyChainService.shared.runningPace = RunningPace(rawValue: self.runningPace)!
                    self.inputs.showCompleteModal.onNext(self.runningPace)
                } else {
                    self.toast.onNext("오류가 발생했습니다. 다시 시도해주세요")
                }
            })
            .disposed(by: disposeBag)

        inputs.showCompleteModal
            .bind(to: routes.showCompleteModal)
            .disposed(by: disposeBag)
    }

    struct Input {
        var registeredAndClose = PublishSubject<Void>()
        var close = PublishSubject<Void>()
        var registerRunningPace = PublishSubject<String>()
        var showCompleteModal = PublishSubject<String>()
        var showCancelModal = PublishSubject<Void>()
    }

    struct Route {
        var registeredAndClose = PublishSubject<Void>()
        var showCancelModal = PublishSubject<Void>()
        var showCompleteModal = PublishSubject<String>()
        var close = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var routes = Route()
}
