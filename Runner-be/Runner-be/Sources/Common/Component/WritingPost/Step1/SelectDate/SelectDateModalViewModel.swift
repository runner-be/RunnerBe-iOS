//
//  EmailCertificationInitModalViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import Foundation
import RxSwift

final class SelectDateModalViewModel: BaseViewModel {
    let currentDate: Date = .init()
    let dateIntervals: [Double]

    override init() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        let dateTodayInterval = calendar.date(from: components)!.timeIntervalSince1970

        dateIntervals = (0 ..< 7).map {
            Date(timeIntervalSince1970: dateTodayInterval + Double($0) * DateStamp.DAY).timeIntervalSince1970
        }
        super.init()

        outputs.dateItems = dateIntervals.map {
            let date = Date(timeIntervalSince1970: $0)
            return DateUtil.shared.formattedString(for: date, format: .MdE)
        }

        inputs.tapOK
            .map { [weak self] _ -> (dateIdx: Int, ampmIdx: Int, timeIdx: Int, minuteIdx: Int)? in
                guard let date = self?.inputs.dateSelected,
                      let ampm = self?.inputs.ampmSelected,
                      let time = self?.inputs.timeSelected,
                      let minute = self?.inputs.minuteSelected
                else { return nil }
                return (dateIdx: date, ampmIdx: ampm, timeIdx: time, minuteIdx: minute)
            }
            .do(onNext: { [weak self] result in
                guard let outputs = self?.outputs, let result = result,
                      result.dateIdx >= 0, result.dateIdx < outputs.dateItems.count,
                      result.ampmIdx >= 0, result.ampmIdx < outputs.ampmItems.count,
                      result.timeIdx >= 0, result.timeIdx < outputs.timeItems.count,
                      result.minuteIdx >= 0, result.minuteIdx < outputs.minuteItems.count
                else {
                    self?.outputs.toast.onNext("일시 입력에 실패하였습니다.")
                    self?.routes.cancel.onNext(())
                    return
                }
            })
            .compactMap { $0 }
            .map { [weak self] result -> Double? in
                guard let self = self
                else { return nil }

                let ampm = result.ampmIdx
                let hourInterval = Double(result.timeIdx + ampm * 12) * DateStamp.HOUR
                let minuteInterval = Double(result.minuteIdx * 5) * DateStamp.MINUTE

                let dateInterval = self.dateIntervals[result.dateIdx] + hourInterval + minuteInterval
                Log.d(tag: .info, "selected interval: \(dateInterval), date: \(Date(timeIntervalSince1970: dateInterval))")
                return dateInterval
            }
            .compactMap { $0 }
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
        // TimeInterval 전달
        var apply = PublishSubject<Double>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
