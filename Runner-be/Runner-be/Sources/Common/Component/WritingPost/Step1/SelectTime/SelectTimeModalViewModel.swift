//
//  EmailCertificationInitModalViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import Foundation
import RxSwift

final class SelectTimeModalViewModel: BaseViewModel {
    override init() {
        super.init()

        inputs.tapOK
            .map { [weak self] _ -> (time: Int, minute: Int)? in
                guard let time = self?.inputs.timeSelected,
                      let minute = self?.inputs.minuteSelected
                else { return nil }
                return (time: time, minute: minute)
            }
            .do(onNext: { [weak self] result in
                guard let outputs = self?.outputs, let result = result,
                      result.time >= 0, result.time < outputs.timeItems.count,
                      result.minute >= 0, result.minute < outputs.minuteItems.count
                else {
                    self?.outputs.toast.onNext("일시 입력에 실패하였습니다.")
                    self?.routes.cancel.onNext(())
                    return
                }
            })
            .compactMap { $0 }
            .map { [weak self] result -> (time: String, minute: String)? in
                guard let outputs = self?.outputs
                else { return nil }
                return (time: outputs.timeItems[result.time],
                        minute: outputs.minuteItems[result.minute])
            }
            .compactMap { $0 }
            .map { "\($0.time)시간 \($0.minute)분" }
            .bind(to: routes.apply)
            .disposed(by: disposeBag)

        inputs.tapBackground
            .bind(to: routes.cancel)
            .disposed(by: disposeBag)
    }

    struct Input {
        var tapBackground = PublishSubject<Void>()
        var tapOK = PublishSubject<Void>()
        var timeSelected: Int = 1
        var minuteSelected: Int = 0
    }

    struct Output {
        let timeItems = ["0", "1", "2", "3", "4"]
        let minuteItems = ["00", "10", "20", "30", "40", "50"]
        var toast = PublishSubject<String>()
    }

    struct Route {
        var cancel = PublishSubject<Void>()
        var apply = PublishSubject<String>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
