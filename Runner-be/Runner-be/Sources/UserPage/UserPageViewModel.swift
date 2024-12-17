//
//  UserPageViewModel.swift
//  Runner-be
//
//  Created by 김창규 on 10/14/24.
//

import Foundation
import RxSwift

final class UserPageViewModel: BaseViewModel {
    // MARK: - Properties

    struct Input {
        var tapLogStampIcon = PublishSubject<Void>()
        var tapLogStamp = PublishSubject<IndexPath>()
        var tapPost = PublishSubject<Int>()
        var tapRunningHeader = PublishSubject<Void>()
        var logStampDidEndDecelerating = PublishSubject<Int>()
    }

    struct Output {
        var userInfo = ReplaySubject<UserConfig>.create(bufferSize: 1)
        var posts = ReplaySubject<[PostConfig]>.create(bufferSize: 1)
        var logStamps = ReplaySubject<[MyLogStampSection]>.create(bufferSize: 1)
        var changeTargetDate = ReplaySubject<(year: Int, month: Int)>.create(bufferSize: 1)
        var days = ReplaySubject<[MyLogStampSection]>.create(bufferSize: 1)
    }

    struct Route {
        var backward = PublishSubject<Void>()
        var calendar = PublishSubject<Int>()
        var confirmLog = PublishSubject<Int>()

        var myRunningList = PublishSubject<Int>()
        var detailPost = PublishSubject<Int>()
    }

    struct RouteInputs {
        var needUpdate = ReplaySubject<Bool>.create(bufferSize: 1)
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInputs()

    var user: User?
    var posts = [Post]()
    private var userRunningLogs: [MyRunningLog?] = []

    typealias LogDate = (date: Date, existGathering: ExistingGathering?, runningLog: MyRunningLog?)
    var dates: [LogDate] = []
    var previousLogStampTotalCount: LogTotalCount?
    var currentLogStampTotalCount: LogTotalCount?

    private let calendar = Calendar.current
    private var components = DateComponents()
    private var targetDate: Date = .init() {
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

    // MARK: - Init

    init(
        userId: Int,
        userAPIService: UserAPIService = BasicUserAPIService(),
        logAPIService: LogAPIService = BasicLogAPIService()
    ) {
        super.init()

        dates += generateWeeks()
        outputs.days.onNext(dates.chunked(into: 7).map { weekDates in
            MyLogStampSection(items: weekDates.map { logDate in
                MyLogStampConfig(
                    from: LogStamp(
                        logId: logDate.runningLog?.logId,
                        gatheringId: logDate.existGathering?.gatheringId,
                        date: logDate.date,
                        stampType: StampType(rawValue: logDate.runningLog?.stampCode ?? ""),
                        isOpened: logDate.runningLog?.isOpened,
                        isGathering: logDate.existGathering != nil
                    )
                )
            })
        })

        // 로그 스탬프
        routeInputs.needUpdate
            .filter { $0 }
            .flatMap { _ in
                let targetDate = Date()

                let currentLog = logAPIService.fetchLog(
                    userId: userId,
                    targetDate: targetDate
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

                var combinedRunningLogs: [MyRunningLog] = []
                var combinedExistingGathering: [ExistingGathering] = []

                switch previousResult {
                case let .response(data):
                    if let data = data {
                        combinedRunningLogs.append(contentsOf: data.myRunningLog)
                        combinedExistingGathering.append(contentsOf: data.isExistGathering)
                        self?.previousLogStampTotalCount = data.totalCount
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
                        combinedRunningLogs.append(contentsOf: data.myRunningLog)
                        combinedExistingGathering.append(contentsOf: data.isExistGathering)
                        self?.currentLogStampTotalCount = data.totalCount
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
                        self?.userRunningLogs = combinedRunningLogs
                    }
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    }
                    return
                }
            })
            .disposed(by: disposeBag)

        routeInputs.needUpdate
            .filter { $0 }
            .flatMap { _ in userAPIService.userPage(userId: userId) }
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.posts.removeAll()
                self.outputs.posts.onNext([])

                switch result {
                case let .response(data):
                    switch data {
                    case let .success(userInfo, userRunningLog, userRunning):
                        self.user = userInfo
                        self.posts = userRunning

                        self.outputs.userInfo.onNext(UserConfig(from: userInfo, owner: false))
                        self.outputs.posts.onNext(self.posts.map { PostConfig(from: $0) })
                    }

                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self.toast.onNext(alertMessage)
                    } else {
                        self.toast.onNext("불러오기에 실패했습니다.")
                    }
                }
            }).disposed(by: disposeBag)

        // 스탬프 클릭 시 스탬프가 있으면 로그 확인 페이지로 이동
        inputs.tapLogStamp
            .compactMap { [weak self] indexPath in
                // 1주 단위로 section으로 구분되어 있습니다.
                let section = indexPath.section * 7
                let item = indexPath.item
                let logItemIndex = section + item
                guard let self = self else { return nil }
                return self.dates[logItemIndex].runningLog?.logId
            }
            .bind(to: routes.confirmLog)
            .disposed(by: disposeBag)

        inputs.tapLogStampIcon
            .map { _ in userId }
            .bind(to: routes.calendar)
            .disposed(by: disposeBag)

        inputs.tapRunningHeader
            .map { _ in userId }
            .bind(to: routes.myRunningList)
            .disposed(by: disposeBag)

        inputs.tapPost
            .compactMap { [weak self] idx in
                guard let self = self,
                      idx >= 0, idx < posts.count
                else {
                    self?.toast.onNext("해당 포스트를 여는데 실패했습니다.")
                    return nil
                }

                print("post id: \(posts[idx].ID)")
                return posts[idx].ID
            }
            .bind(to: routes.detailPost)
            .disposed(by: disposeBag)

        inputs.logStampDidEndDecelerating
            .compactMap { [weak self] sectionIndex in
                guard let self = self else { return nil }
                if sectionIndex != 2 { // 1,2페이지에서만 계산, 3페이지는 현재날짜로 고정
                    let firstDateIndex = sectionIndex * 7 // 일주일 단위 7
                    let firstDateOfSection: Date = dates[firstDateIndex].date
                    let sectionYear = calendar.component(.year, from: firstDateOfSection)
                    let sectionMonth = calendar.component(.month, from: firstDateOfSection)

                    let targetPreDate = calendar.date(byAdding: .month, value: -1, to: targetDate)! // 타겟 날짜의 이전 달
                    let targetPreMonth = calendar.dateComponents([.year, .month], from: targetPreDate).month

                    return (year: sectionYear, month: sectionMonth)
                }
                return (year: targetYear, month: targetMonth)
            }
            .bind(to: outputs.changeTargetDate)
            .disposed(by: disposeBag)
    }

    // MARK: - Methods

    private func changeTargetDate(
        runningLog: [MyRunningLog],
        existingGathering: [ExistingGathering]
    ) {
        if let _ = calendar.date(from: components) {
            userRunningLogs.removeAll()
            dates.removeAll()

            dates += generateWeeks()
            markMonthGatheringDates(existingGathering)
            outputs.days.onNext(markMonthLogDates(runningLogs: runningLog))
            outputs.changeTargetDate.onNext((
                year: targetYear,
                month: targetMonth
            ))
        }
    }

    private func getWeek(for date: Date) -> [Date] {
        let calendar = Calendar.current

        // 날짜의 요일을 가져옵니다. 1은 일요일, 2는 월요일, ..., 7은 토요일입니다.
        let weekDay = calendar.component(.weekday, from: date)

        // 주의 시작을 월요일로 가정하고, 해당 주의 월요일로 이동하기 위한 오프셋 계산
        let startOfWeekOffset = (weekDay == 1 ? -6 : 2 - weekDay)
        let startOfWeek = calendar.date(byAdding: .day, value: startOfWeekOffset, to: date)!

        // 월요일부터 일요일까지의 날짜 리스트 생성
        var weekDates: [Date] = []
        for i in 0 ..< 7 {
            if let weekDate = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                weekDates.append(weekDate)
            }
        }

        return weekDates
    }
}

extension UserPageViewModel {
    func generateWeeks() -> [LogDate] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        let daysPerWeek = 7
        // 현재 주와 이전 2주의 날짜들을 가져옴
        let currentWeek = getWeek(for: Date())
        let previousWeek = getWeek(for: calendar.date(byAdding: .weekOfYear, value: -1, to: Date())!)
        let twoWeeksAgo = getWeek(for: calendar.date(byAdding: .weekOfYear, value: -2, to: Date())!)

        // 날짜 배열 합치기
        let weeks: [Date] = twoWeeksAgo + previousWeek + currentWeek

        return weeks.map { LogDate(
            date: $0,
            existGathering: nil,
            runningLog: nil
        ) }
    }

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

    func markMonthLogDates(runningLogs: [MyRunningLog]) -> [MyLogStampSection] {
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

        // myLogStampsConfigs 배열을 7개씩 그룹화하여 MyLogStampSection으로 변환
        return myLogStampsConfigs.chunked(into: 7).map { weekConfigs in
            MyLogStampSection(items: weekConfigs)
        }
    }
}
