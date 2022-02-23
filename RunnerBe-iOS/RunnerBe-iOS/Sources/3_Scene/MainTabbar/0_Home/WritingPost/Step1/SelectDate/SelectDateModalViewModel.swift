//
//  EmailCertificationInitModalViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import Foundation
import RxSwift

final class SelectDateModalViewModel: BaseViewModel {
    init(dateService: DateService) {
        super.init()

        outputs.dateItems = dateService.getRange(format: .MdE, startDate: Date(), dayOffset: 7)
        // TODO: DateService에서 현재 날짜로부터 일주일 사이의 날들을 계산하여 배열 생성하기
//        outputs.dateItems = ["3/31 (목)", "4/1 (금)", "4/2 (토)", "4/3 (일)", "4/4 (월)", "4/5 (화)", "4/6 (수)", "4/7 (목)"]

        inputs.tapOK
            .map { [weak self] _ -> (date: Int, ampm: Int, time: Int, minute: Int)? in
                guard let date = self?.inputs.dateSelected,
                      let ampm = self?.inputs.ampmSelected,
                      let time = self?.inputs.timeSelected,
                      let minute = self?.inputs.minuteSelected
                else { return nil }
                return (date: date, ampm: ampm, time: time, minute: minute)
            }
            .do(onNext: { [weak self] result in
                guard let outputs = self?.outputs, let result = result,
                      result.date >= 0, result.date < outputs.dateItems.count,
                      result.ampm >= 0, result.ampm < outputs.ampmItems.count,
                      result.time >= 0, result.time < outputs.timeItems.count,
                      result.minute >= 0, result.minute < outputs.minuteItems.count
                else {
                    self?.outputs.toast.onNext("일시 입력에 실패하였습니다.")
                    self?.routes.cancel.onNext(())
                    return
                }
            })
            .compactMap { $0 }
            .map { [weak self] result -> (date: String, ampm: String, time: String, minute: String)? in
                guard let outputs = self?.outputs
                else { return nil }
                return (date: outputs.dateItems[result.date],
                        ampm: outputs.ampmItems[result.ampm],
                        time: outputs.timeItems[result.time],
                        minute: outputs.minuteItems[result.minute])
            }
            .compactMap { $0 }
            .map { "\($0.date) \($0.ampm) \($0.time):\($0.minute)" }
            .bind(to: routes.apply)
            .disposed(by: disposeBag)

        inputs.tapBackground
            .bind(to: routes.cancel)
            .disposed(by: disposeBag)
    }

    struct Input {
        var tapBackground = PublishSubject<Void>()
        var tapOK = PublishSubject<Void>()

        var dateSelected: Int = 0
        var ampmSelected: Int = 0
        var timeSelected: Int = 0
        var minuteSelected: Int = 0
    }

    struct Output {
        var dateItems: [String] = []
        let ampmItems = ["AM", "PM"]
        let timeItems = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"]
        let minuteItems = ["00", "5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55"]
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
