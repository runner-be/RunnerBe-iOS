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

    typealias LogDate = (date: Date, existGathering: ExistingGathering?, runningLog: MyRunningLog?)
    var dates: [LogDate] = []
    var myLogStampsConfigs: [MyLogStampConfig] = []

    let loginKeyChain: LoginKeyChainService
    var isMyLogStamp: Bool = false

    // MARK: - Init

    init(
        userId: Int,
        logAPIService: LogAPIService = BasicLogAPIService(),
        loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared
    ) {
        targetDate = Date()

        loginKeyChain = loginKeyChainService
        isMyLogStamp = userId == loginKeyChain.userId

        super.init()

        inputs.changedTargetDate.onNext(Date())

        // 날짜 초기화
        dates += generatePreviousMonthDates(targetDate)
        dates += generateCurrentMonthDates(targetDate)
        dates += generateNextMonthDates(targetDate)
        outputs.days.onNext(dates.map {
            MyLogStampConfig(
                from: LogStamp(
                    logId: nil,
                    gatheringId: nil,
                    date: $0.date,
                    stampType: nil,
                    isOpened: nil,
                    isGathering: $0.existGathering != nil
                )
            )
        })

        inputs.changedTargetDate
            .flatMap { targetDate in
                let currentDate = targetDate
                let currentLog = logAPIService.fetchLog(
                    userId: userId,
                    targetDate: currentDate
                )

                guard let previousDateMonthDate = Calendar.current.date(byAdding: .month, value: -1, to: targetDate) else {
                    return Observable.zip(
                        currentLog,
                        Observable.just(APIResult<LogResponse?>.response(result: nil)),
                        Observable.just(APIResult<LogResponse?>.response(result: nil))
                    )
                }

                let previousLog = logAPIService.fetchLog(
                    userId: userId,
                    targetDate: previousDateMonthDate
                )

                guard let nextDateMonthDate = Calendar.current.date(byAdding: .month, value: +1, to: targetDate) else {
                    return Observable.zip(
                        currentLog,
                        previousLog,
                        Observable.just(APIResult<LogResponse?>.response(result: nil))
                    )
                }

                let nextLog = logAPIService.fetchLog(
                    userId: userId,
                    targetDate: nextDateMonthDate
                )

                return Observable.zip(currentLog, previousLog, nextLog)
            }
            .subscribe(onNext: { [weak self] currentResult, previousResult, nextResult in
//                //                guard let self = self else { return }
                var combinedRunningLogs: [MyRunningLog] = []
                var combinedExistingGathering: [ExistingGathering] = []

                switch previousResult {
                case let .response(data):
                    if let data = data {
                        combinedRunningLogs.append(contentsOf: data.myRunningLog)
                        combinedExistingGathering.append(contentsOf: data.isExistGathering)
                    }
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    }
                    return
                }

                switch currentResult {
                case let .response(data):
                    if let data = data {
                        self?.outputs.logTotalCount.onNext(data.totalCount)

                        combinedRunningLogs.append(contentsOf: data.myRunningLog)
                        combinedExistingGathering.append(contentsOf: data.isExistGathering)
                    }
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    }
                    return
                }

                switch nextResult {
                case let .response(data):
                    if let data = data {
                        combinedRunningLogs.append(contentsOf: data.myRunningLog)
                        combinedExistingGathering.append(contentsOf: data.isExistGathering)

                        self?.changeTargetDate(
                            runningLog: combinedRunningLogs,
                            existingGathering: combinedExistingGathering
                        )
                        self?.myRunningLogs = combinedRunningLogs
                    }
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    }
                    return
                }
            })
            .disposed(by: disposeBag)

        // 로그가 있는 날짜를 클릭했을 때
        inputs.tappedDate
            .compactMap { [weak self] index -> MyRunningLog? in
                guard let self = self,
                      let runningLog = self.dates[index].runningLog
                else {
                    return nil
                }
                return runningLog
            }
            .filter { [weak self] runningLog in
                guard let self = self else { return false }
                return self.isMyLogStamp || runningLog.isOpened == 1
            }
            .compactMap {
                $0.logId
            }
            .bind(to: routes.confirmLog)
            .disposed(by: disposeBag)

        // 로그가 없는 날짜를 클릭했을 때
        inputs.tappedDate
            .filter { [weak self] _ in
                guard let self = self else { return false }
                return self.isMyLogStamp
            }
            .compactMap { [weak self] index in
                let currentDate = Date()

                guard let self = self,
                      self.dates[index].runningLog == nil,
                      currentDate.timeIntervalSince1970 > self.dates[index].date.timeIntervalSince1970
                else {
                    return nil
                }
                return LogForm(
                    runningDate: self.dates[index].date,
                    gatheringId: self.dates[index].existGathering?.gatheringId,
                    isOpened: 1
                )
            }
            .bind(to: routes.writeLog)
            .disposed(by: disposeBag)

        inputs.showSelectDate
            .map { [weak self] _ in
                guard let self = self else { return Date() }
                return self.targetDate
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

    // MARK: - Methods

    func changeTargetDate(
        runningLog: [MyRunningLog],
        existingGathering: [ExistingGathering]
    ) {
        if let _ = calendar.date(from: components) {
            myRunningLogs.removeAll()
            dates.removeAll()

            dates += generatePreviousMonthDates(targetDate)
            dates += generateCurrentMonthDates(targetDate)
            dates += generateNextMonthDates(targetDate)
            markMonthGatheringDates(existingGathering)
            outputs.days.onNext(markMonthLogDates(runningLogs: runningLog))

            outputs.changedTargetDate.onNext((
                year: targetYear,
                month: targetMonth
            ))
        }
    }

    struct Input {
        var showSelectDate = PublishSubject<Void>()
        var changedTargetDate = ReplaySubject<Date>.create(bufferSize: 1)
        var tappedDate = PublishSubject<Int>()
    }

    struct Output {
        var days = ReplaySubject<[MyLogStampConfig]>.create(bufferSize: 1)
        var changedTargetDate = ReplaySubject<(year: Int, month: Int)>.create(bufferSize: 2)
        var logTotalCount = ReplaySubject<LogTotalCount>.create(bufferSize: 1)
    }

    struct Route {
        var backward = PublishSubject<Void>()
        var dateBottomSheet = PublishSubject<Date>()
        var confirmLog = PublishSubject<Int>()
        var writeLog = PublishSubject<LogForm>()
    }

    struct RouteInput {
        var needUpdate = ReplaySubject<(targetDate: Date?, needUpdate: Bool)>.create(bufferSize: 1)
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}

// MARK: - 선택된 달을 기준으로 이전달, 현재달, 다음달의 날짜 배열을 계산합니다.

extension CalendarViewModel {
    func generatePreviousMonthDates(_ targetDate: Date) -> [LogDate] {
        var previousDates = [LogDate]()

        // 오늘 날짜의 요일 계산 (1 = 일요일, 2 = 월요일, ..., 7 = 토요일)
        let startOfMonth = targetDate.startOfMonth()
        let weekdayOfFirstDayInMonth = calendar.component(.weekday, from: startOfMonth)

        // 달력은 월요일부터 시작하므로 월요일이 첫 번째가 되도록 조정
        let adjustedWeekdayOfFirstDay = (weekdayOfFirstDayInMonth == 1) ? 7 : weekdayOfFirstDayInMonth - 1

        if adjustedWeekdayOfFirstDay > 1 {
            let previousMonth = calendar.date(byAdding: .month, value: -1, to: targetDate)!
            let rangeOfPreviousMonth = calendar.range(of: .day, in: .month, for: previousMonth)!

            // Calendar에 시간대 설정 (예: UTC)
            var utcCalendar = calendar
            utcCalendar.timeZone = TimeZone(identifier: "UTC")!

            let lastDayOfPreviousMonth = rangeOfPreviousMonth.count
            let daysToAdd = adjustedWeekdayOfFirstDay - 1

            for i in 0 ..< daysToAdd {
                let dayOfPreviousMonth = lastDayOfPreviousMonth - daysToAdd + i + 1
                var dateComponents = calendar.dateComponents([.year, .month], from: previousMonth)
                dateComponents.day = dayOfPreviousMonth
                dateComponents.timeZone = utcCalendar.timeZone
                if let date = calendar.date(from: dateComponents) {
                    previousDates.append(LogDate(
                        date: date,
                        existGathering: nil,
                        runningLog: nil
                    ))
                }
            }
        }

        return previousDates
    }

    func generateCurrentMonthDates(_ targetDate: Date) -> [LogDate] {
        var currentDates = [LogDate]()
        let rangeOfCurrentMonth = calendar.range(of: .day, in: .month, for: targetDate)!

        // 오늘 날짜의 요일 계산 (1 = 일요일, 2 = 월요일, ..., 7 = 토요일)
        let startOfMonth = targetDate.startOfMonth()

        // targetDate의 연도와 월을 가져옵니다.
        var components = calendar.dateComponents([.year, .month], from: targetDate)
        components.timeZone = TimeZone(identifier: "UTC")!

        for day in rangeOfCurrentMonth {
            // day를 사용하여 `Date`를 만듭니다.
            var dateComponents = components
            dateComponents.day = day

            // 날짜를 생성하고 MyLogStampConfig 객체를 반환합니다.
            if let date = calendar.date(from: dateComponents) {
                currentDates.append(LogDate(
                    date: date,
                    existGathering: nil,
                    runningLog: nil
                ))
            }
        }

        return currentDates
    }

    func generateNextMonthDates(_ targetDate: Date) -> [LogDate] {
        var nextDates = [LogDate]()
        var utcCalendar = calendar
        utcCalendar.timeZone = TimeZone(identifier: "UTC")!

        // 남은 칸을 다음 달의 날짜로 채우기
        let totalCells = dates.count > 35 ? 42 : 35
        let remainingDays = totalCells - dates.count

        if remainingDays > 0 {
            // 다음 달의 첫 번째 날을 계산
            var components = utcCalendar.dateComponents([.year, .month], from: targetDate)
            components.month = (components.month ?? 1) + 1
            components.day = 1

            if let nextMonthStart = utcCalendar.date(from: components) {
                for day in 1 ... remainingDays {
                    if let date = utcCalendar.date(byAdding: .day, value: day - 1, to: nextMonthStart) {
                        nextDates.append(LogDate(
                            date: date,
                            existGathering: nil,
                            runningLog: nil
                        ))
                    }
                }
            }
        }

        return nextDates
    }
}

// MARK: - 로그 전체 조회 API를 통해 가져온 데이터를 설정합니다.

extension CalendarViewModel {
    func markMonthGatheringDates(_ existingGathering: [ExistingGathering]) {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!

        // 최대 4만번
        for i in 0 ..< dates.count {
            for element in existingGathering {
                if let gatheringDate = element.gatheringTime.toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ") {
                    if calendar.isDate(gatheringDate, inSameDayAs: dates[i].date) {
                        print("Matching date found: \(dates[i].date), \(element)")
                        dates[i].existGathering = element
                        break
                    }
                }
            }
        }
    }

    func markMonthLogDates(runningLogs: [MyRunningLog]) -> [MyLogStampConfig] {
        var myLogStampsConfigs = [MyLogStampConfig]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        for i in 0 ..< dates.count {
            var logFound = false // 로그가 발견되었는지 여부를 확인합니다.
            for log in runningLogs {
                // runningLog와 동일한 날짜가 있는지 확인
                if let logDate = dateFormatter.date(from: log.runnedDate) {
                    if calendar.isDate(logDate, inSameDayAs: dates[i].date) {
                        let config = MyLogStampConfig(from: LogStamp(
                            logId: log.logId,
                            gatheringId: log.gatheringId,
                            date: dates[i].date,
                            stampType: StampType(rawValue: log.stampCode ?? ""),
                            isOpened: log.isOpened,
                            isGathering: dates[i].existGathering != nil
                        ))
                        myLogStampsConfigs.append(config)
                        dates[i].runningLog = log
                        logFound = true // 로그를 찾았음을 표시
                        break
                    }
                }
            }

            // 로그가 발견되지 않았을 경우 기본 값을 추가
            if !logFound {
                myLogStampsConfigs.append(MyLogStampConfig(from: LogStamp(
                    logId: nil,
                    gatheringId: nil,
                    date: dates[i].date,
                    stampType: nil,
                    isOpened: nil,
                    isGathering: dates[i].existGathering != nil
                )))
            }
        }

        return myLogStampsConfigs
    }
}
