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
    }

    struct Output {
        var userInfo = ReplaySubject<UserConfig>.create(bufferSize: 1)
        var posts = ReplaySubject<[MyPagePostConfig]>.create(bufferSize: 1)
        var logStamps = ReplaySubject<[MyLogStampSection]>.create(bufferSize: 1)
        var changeTargetDate = ReplaySubject<(year: Int, month: Int)>.create(bufferSize: 1)
    }

    struct Route {
        var backward = PublishSubject<Void>()
        var calendar = PublishSubject<Void>()
        var confirmLog = PublishSubject<Int>()
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
        userId _: Int,
        userAPIService: UserAPIService = BasicUserAPIService()
    ) {
        super.init()

        outputs.changeTargetDate.onNext((
            year: targetYear,
            month: targetMonth
        ))

        userAPIService.userPage(userId: 414)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.posts.removeAll()
                self.outputs.posts.onNext([])

                switch result {
                case let .response(data):
                    switch data {
                    case let .success(userInfo, userRunningLog, userRunning):
                        let now = DateUtil.shared.now

                        self.user = userInfo
                        self.posts = userRunning

                        self.outputs.userInfo.onNext(UserConfig(from: userInfo, owner: false))
                        self.changeTargetDate(runningLog: userRunningLog)
                        self.outputs.posts.onNext(userRunning.map { MyPagePostConfig(post: $0, now: now) })
                    }

                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self.toast.onNext(alertMessage)
                    } else {
                        self.toast.onNext("불러오기에 실패했습니다.")
                    }
                }
            }).disposed(by: disposeBag)

        inputs.tapLogStamp
            .compactMap { [weak self] indexPath -> MyRunningLog? in
                // 1주 단위로 section으로 구분되어 있습니다.
                let section = indexPath.section * 7
                let item = indexPath.item
                let logItemIndex = section + item
                guard let self = self else { return nil }

                return self.userRunningLogs[logItemIndex]
            }
            .filter { logItem in
                logItem.isOpened == 1
            }
            .compactMap { logItem in
                logItem.logId
            }
            .bind(to: routes.confirmLog)
            .disposed(by: disposeBag)

        inputs.tapLogStampIcon
            .bind(to: routes.calendar)
            .disposed(by: disposeBag)
    }

    // MARK: - Methods

    private func changeTargetDate(runningLog: [MyRunningLog]) {
        userRunningLogs.removeAll()
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

        // `weeks` 배열을 `MyLogStampConfig` 배열로 변환
        let myLogStampConfigs: [MyLogStampConfig] = weeks.map { date in
            var stampType: StampType?
            var logId: Int?
            var gatheringId: Int?
            var isOpened: Int?

            for log in runningLog {
                if let logDate = dateFormatter.date(from: log.runnedDate) {
                    if calendar.isDate(logDate, inSameDayAs: date) {
                        stampType = StampType(rawValue: log.stampCode ?? "")
                        logId = log.logId
                        gatheringId = log.gatheringId
                        isOpened = log.isOpened
                        break
                    } else {
                        stampType = nil
                    }
                }
            }

            userRunningLogs.append(MyRunningLog(
                logId: logId,
                gatheringId: gatheringId,
                runnedDate: date.description,
                stampCode: stampType?.rawValue,
                isOpened: isOpened
            ))

            return MyLogStampConfig(from: LogStamp(
                logId: logId,
                gatheringId: gatheringId,
                date: date,
                stampType: stampType,
                isOpened: isOpened
            ))
        }

        // 7개씩 끊어서 `MyLogStampSection`을 만듦
        let sections = stride(from: 0, to: myLogStampConfigs.count, by: daysPerWeek).map { startIndex -> MyLogStampSection in
            let endIndex = min(startIndex + daysPerWeek, myLogStampConfigs.count)
            let items = Array(myLogStampConfigs[startIndex ..< endIndex])
            return MyLogStampSection(items: items)
        }

        // ViewModel Output에 섹션 전달
        outputs.logStamps.onNext(sections)
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
