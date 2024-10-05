//
//  CalendarViewModel.swift
//  Runner-be
//
//  Created by 김창규 on 8/27/24.
//

import Foundation
import RxSwift

final class CalendarViewModel: BaseViewModel {
    // MARK: - Properties

    private var myRunningLogs: [MyRunningLog?] = []
    private let calendar = Calendar.current
    private var components = DateComponents()
    var targetDate: Date {
        didSet {
            components.year = targetYear
            components.month = targetMonth
            components.day = 1
        }
    }

    var targetYear: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let yearString = formatter.string(from: targetDate)
        return Int(yearString) ?? 0000
    }

    var targetMonth: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        let monthString = formatter.string(from: targetDate)
        return Int(monthString) ?? 00
    }

    var dates: [MyLogStampConfig] = []

    // MARK: - Init

    init(logAPIService: LogAPIService = BasicLogAPIService()) {
        targetDate = Date()
        super.init()

        inputs.changedTargetDate
            .flatMap { logAPIService.fetchLog(targetDate: $0) }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case let .response(data):
                    if let data = data {
                        self?.outputs.logTotalCount.onNext(data.totalCount)
                        self?.changeTargetDate(runningLog: data.myRunningLog)
                    }
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    }
                    return
                }
            })
            .disposed(by: disposeBag)

        inputs.tappedDate
            .compactMap { [weak self] index in
                guard let self = self,
                      let logId = self.myRunningLogs[index]?.logId
                else {
                    return nil
                }

                return logId
            }
            .bind(to: routes.confirmLog)
            .disposed(by: disposeBag)

        inputs.tappedDate
            .compactMap { [weak self] index in
                let currentDate = Date()

                guard let self = self,
                      self.myRunningLogs[index]?.logId == nil,
                      currentDate.timeIntervalSince1970 > self.dates[index].date.timeIntervalSince1970
                else {
                    return nil
                }
                return LogForm(
                    runningDate: self.dates[index].date,
                    isOpened: 1
                )
            }
            .bind(to: routes.writeLog)
            .disposed(by: disposeBag)

        inputs.showSelectDate
            .map { [weak self] _ in
                guard let self = self else { return Date() }
                return targetDate
            }
            .bind(to: routes.dateBottomSheet)
            .disposed(by: disposeBag)

        routeInputs.needUpdate
            .filter { $0.needUpdate }
            .compactMap { [weak self] targetDate, _ in
                if let targetDate = targetDate {
                    self?.targetDate = targetDate
                }
                return self?.targetDate
            }
            .bind(to: inputs.changedTargetDate)
            .disposed(by: disposeBag)
    }

    func changeTargetDate(runningLog: [MyRunningLog]) {
        if let _ = calendar.date(from: components) {
            myRunningLogs.removeAll()
            outputs.days.onNext(generateCalendarDates(runningLog: runningLog))
            outputs.changedTargetDate.onNext((
                year: targetYear,
                month: targetMonth
            ))
        }
    }

    func generateCalendarDates(runningLog: [MyRunningLog]) -> [MyLogStampConfig] {
        dates = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        // 오늘 날짜의 요일 계산 (1 = 일요일, 2 = 월요일, ..., 7 = 토요일)
        let startOfMonth = targetDate.startOfMonth()
        let weekdayOfFirstDayInMonth = calendar.component(.weekday, from: startOfMonth)

        // 달력은 월요일부터 시작하므로 월요일이 첫 번째가 되도록 조정
        let adjustedWeekdayOfFirstDay = (weekdayOfFirstDayInMonth == 1) ? 7 : weekdayOfFirstDayInMonth - 1

        // 이전 달의 날짜 계산
        if adjustedWeekdayOfFirstDay > 1 {
            let previousMonth = calendar.date(byAdding: .month, value: -1, to: targetDate)!
            let rangeOfPreviousMonth = calendar.range(of: .day, in: .month, for: previousMonth)!

            for i in stride(from: adjustedWeekdayOfFirstDay - 1, through: 1, by: -1) {
                let dayOfPreviousMonth = rangeOfPreviousMonth.count - i + 1
                let date = previousMonth.with(day: dayOfPreviousMonth)!
                dates.append(MyLogStampConfig(from: LogStamp(
                    logId: nil,
                    gatheringId: nil,
                    date: date,
                    stampType: nil
                )))

                myRunningLogs.append(nil)
            }
        }

        // 이번달
        let calendar = Calendar.current
        let rangeOfCurrentMonth = calendar.range(of: .day, in: .month, for: targetDate)!
        for day in rangeOfCurrentMonth {
            let date = startOfMonth.with(day: day)!
            var stampType: StampType?
            var logId: Int?
            var gatheringId: Int?

            for log in runningLog {
                // runningLog와 동일한 날짜가 있는지 확인
                if let logDate = dateFormatter.date(from: log.runnedDate) {
                    if calendar.isDate(logDate, inSameDayAs: date) {
                        stampType = StampType(rawValue: log.stampCode ?? "")
                        logId = log.logId
                        gatheringId = log.gatheringId
                        break
                    } else {
                        stampType = nil
                    }
                }
            }

            dates.append(MyLogStampConfig(from: LogStamp(
                logId: logId,
                gatheringId: gatheringId,
                date: date,
                stampType: stampType
            )))

            myRunningLogs.append(MyRunningLog(
                logId: logId,
                gatheringId: gatheringId,
                runnedDate: date.description,
                stampCode: stampType?.rawValue
            ))
        }

        // 남은 칸을 다음 달의 날짜로 채우기
        let totalCells = dates.count > 35 ? 42 : 35
        if dates.count < totalCells {
            let remainingDays = totalCells - dates.count
            let nextMonth = calendar.date(byAdding: .month, value: 1, to: targetDate)!
            for day in 1 ... remainingDays {
                let date = nextMonth.with(day: day)!
                dates.append(MyLogStampConfig(from: LogStamp(
                    logId: nil,
                    gatheringId: nil,
                    date: date,
                    stampType: nil
                )))

                myRunningLogs.append(nil)
            }
        }

        return dates
    }

    struct Input {
        var showSelectDate = PublishSubject<Void>()
        var changedTargetDate = ReplaySubject<Date>.create(bufferSize: 1)
        var tappedDate = PublishSubject<Int>()
    }

    struct Output {
        var days = ReplaySubject<[MyLogStampConfig]>.create(bufferSize: 1)
        var changedTargetDate = PublishSubject<(year: Int, month: Int)>()
        var logTotalCount = ReplaySubject<LogTotalCount>.create(bufferSize: 1)
    }

    struct Route {
        var backward = PublishSubject<Void>()
        var dateBottomSheet = PublishSubject<Date>()
        var confirmLog = PublishSubject<Int>()
        var writeLog = PublishSubject<LogForm>()
    }

    struct RouteInput {
        var needUpdate = PublishSubject<(targetDate: Date?, needUpdate: Bool)>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
