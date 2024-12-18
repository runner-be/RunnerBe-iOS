//
//  MyPageViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import RxSwift

final class MyPageViewModel: BaseViewModel {
    // MARK: - Properties

    var dirty: Bool = false

    enum PostType {
        case myPost, attendable
    }

    var user: User?
    var posts = [Post]()
    private var myRunningLogs: [MyRunningLog?] = []

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
        postAPIService: PostAPIService = BasicPostAPIService(),
        userAPIService: UserAPIService = BasicUserAPIService(),
        logAPIService: LogAPIService = BasicLogAPIService(),
        loginKeyChain: LoginKeyChainService = BasicLoginKeyChainService.shared
    ) {
        super.init()
        let userId = loginKeyChain.userId ?? 0

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
                        self?.outputs.logTotalCount.onNext(data.totalCount)
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

        routeInputs.needUpdate
            .filter { $0 }
            .flatMap { _ in postAPIService.myPage() }
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }

                switch result {
                case let .response(result: data):
                    switch data {
                    case let .success(info, _, joined):
                        self.user = info
                        self.posts = joined.reversed()

                        self.outputs.userInfo.onNext(UserConfig(from: info, owner: false))
                        self.outputs.posts.onNext(self.posts.map { PostConfig(from: $0) })
                    }
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self.toast.onNext(alertMessage)
                    } else {
                        self.toast.onNext("불러오기에 실패했습니다.")
                    }
                }
            })
            .disposed(by: disposeBag)

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

        // 스탬프 클릭 시 스탬프가 없으면 개인 로그 작성 페이지로 이동
        inputs.tapLogStamp
            .compactMap { [weak self] indexPath in
                let currentDate = Date()
                // 1주 단위로 section으로 구분되어 있습니다.
                let section = indexPath.section * 7
                let item = indexPath.item
                let logItemIndex = section + item

                guard let self = self,
                      self.dates[logItemIndex].runningLog == nil,
                      currentDate.timeIntervalSince1970 > self.dates[logItemIndex].date.timeIntervalSince1970
                else {
                    return nil
                }
                return LogForm(
                    runningDate: self.dates[logItemIndex].date,
                    gatheringId: self.dates[logItemIndex].existGathering?.gatheringId,
                    isOpened: 1
                )
            }
            .bind(to: routes.writeLog)
            .disposed(by: disposeBag)

        inputs.tapLogStampIcon
            .map { userId }
            .bind(to: routes.calendar)
            .disposed(by: disposeBag)

        inputs.tapMyRunning
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

        inputs.bookMark
            .compactMap { [weak self] idx -> Post? in
                guard let self = self,
                      idx >= 0, idx < posts.count
                else {
                    self?.toast.onNext("북마크를 실패했습니다.")
                    return nil
                }
                return posts[idx]
            }
            .flatMap { postAPIService.bookmark(postId: $0.ID, mark: !$0.marked) }
            .do(onNext: { [weak self] result in
                switch result {
                case .response:
                    return
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    }
                }
            })
            .compactMap { result -> (postId: Int, mark: Bool)? in
                switch result {
                case let .response(data):
                    return data
                case .error:
                    return nil
                }
            }
            .subscribe(onNext: { [weak self] result in
                guard let self = self,
                      let idx = posts.firstIndex(where: { $0.ID == result.postId })
                else {
                    self?.toast.onNext("북마크를 실패했습니다.")
                    return
                }

                self.posts[idx].marked = result.mark
                self.outputs.posts.onNext(self.posts.map { PostConfig(from: $0) })
            })
            .disposed(by: disposeBag)

        inputs.attend
            .compactMap { [weak self] idx -> Post? in
                guard let self = self,
                      idx >= 0, idx < posts.count
                else {
                    self?.toast.onNext("참석하기 요청중 오류가 발생했습니다.")
                    return nil
                }
                return posts[idx]
            }
            .flatMap { postAPIService.attendance(postId: $0.ID) }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case let .response(result: data):
                    guard data.success,
                          let self = self,
                          let idx = posts.firstIndex(where: { $0.ID == data.postId })
                    else {
                        self?.toast.onNext("참석하기 요청중 오류가 발생했습니다.")
                        return
                    }
                    self.outputs.attend.onNext((type: self.outputs.postType, idx: idx, state: ParticipateAttendState.absence))
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    } else {
                        self?.toast.onNext("참석하기 요청중 오류가 발생했습니다.")
                    }
                }
            })
            .disposed(by: disposeBag)

        inputs.settings
            .map { self.user?.pushOn ?? "N" }
            .bind(to: routes.settings)
            .disposed(by: disposeBag)

        inputs.editInfo
            .compactMap { [weak self] _ -> User? in
                if let user = self?.user {
                    return user
                }
                self?.toast.onNext("내 정보를 가져오는데 실패했습니다.")
                return nil
            }
            .bind(to: routes.editInfo)
            .disposed(by: disposeBag)

        inputs.toMain
            .bind(to: routes.toMain)
            .disposed(by: disposeBag)

        inputs.writePost
            .bind(to: routes.writePost)
            .disposed(by: disposeBag)

        Observable<String?>.of(user?.profileImageURL)
            .subscribe(outputs.currentProfile)
            .disposed(by: disposeBag)

        inputs.changePhoto
            .bind(to: routes.photoModal)
            .disposed(by: disposeBag)

        routeInputs.photoTypeSelected
            .compactMap { $0 }
            .bind(to: outputs.showPicker)
            .disposed(by: disposeBag)

        inputs.photoSelected
            .do(onNext: { [weak self] _ in
                self?.toastActivity.onNext(true)
            })
            .compactMap { [weak self] data in
                if data == nil {
                    self?.toastActivity.onNext(false)
                    self?.toast.onNext("이미지 불러오기에 실패했어요")
                }
                return data
            }
            .flatMap { userAPIService.setProfileImage(to: $0) }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case let .succeed(data):
                    self?.outputs.profileChanged.onNext(data)
                    self?.dirty = true
                case .error:
                    self?.toast.onNext("이미지 등록에 실패했어요")
                }
                self?.toastActivity.onNext(false)
            })
            .disposed(by: disposeBag)

        inputs.changeToDefaultProfile
            .flatMap { userAPIService.setProfileImage(to: nil) }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .succeed:
                    self?.outputs.profileChanged.onNext(nil)
                    self?.dirty = true
                case .error:
                    self?.toast.onNext("기본 이미지 변경에 실패했어요")
                }
                self?.toastActivity.onNext(false)
            })
            .disposed(by: disposeBag)

        inputs.registerRunningPace
            .bind(to: routes.registerRunningPace)
            .disposed(by: disposeBag)

        inputs.tapWriteLog
            .compactMap { [weak self] itemIndex in
                guard let self = self else {
                    return nil
                }
                let selectedPost = self.posts[itemIndex]
                return LogForm(
                    runningDate: selectedPost.gatherDate,
                    logId: selectedPost.ID,
                    gatheringId: selectedPost.gatheringId,
                    stampCode: nil,
                    contents: nil,
                    imageUrl: nil,
                    weatherDegree: nil,
                    weatherIcon: nil,
                    isOpened: 1
                )
            }
            .bind(to: routes.writeLog)
            .disposed(by: disposeBag)

        inputs.tapConfirmLog
            .compactMap { [weak self] itemIndex in
                guard let self = self else {
                    return nil
                }
                let selectedPost = self.posts[itemIndex]
                return selectedPost.logId
            }
            .bind(to: routes.confirmLog)
            .disposed(by: disposeBag)

        inputs.tapManageAttendance
            .compactMap { [weak self] index in
                guard let self = self else { return nil }
                return posts[index].ID
            }
            .bind(to: routes.manageAttendance)
            .disposed(by: disposeBag)

        inputs.tapConfirmAttendance
            .compactMap { [weak self] index in
                guard let self = self else { return nil }
                return posts[index].ID
            }
            .bind(to: routes.confirmAttendance)
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

                    let isPreMonth = (sectionMonth == targetPreMonth) // 타겟 날짜의 이전 달인가?

                    if isPreMonth { // 이전달이면 이전달의 로그 횟수가져온다.
                        if let totalCount = previousLogStampTotalCount {
                            self.outputs.logTotalCount.onNext(totalCount)
                        }
                    } else { // 이전달이 아니면 현재 로그 횟수를 가져온다.
                        if let totalCount = currentLogStampTotalCount {
                            self.outputs.logTotalCount.onNext(totalCount)
                        }
                    }

                    return (year: sectionYear, month: sectionMonth)
                }

                if let totalCount = currentLogStampTotalCount {
                    self.outputs.logTotalCount.onNext(totalCount)
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
            myRunningLogs.removeAll()
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

    struct Input {
        var typeChanged = PublishSubject<PostType>() // subscribe 된 시점 이후부터 발생한 이벤트를 전달
        var settings = PublishSubject<Void>()
        var editInfo = PublishSubject<Void>()
        var tapPost = PublishSubject<Int>()
        var tapLogStamp = PublishSubject<IndexPath>()
        var tapLogStampIcon = PublishSubject<Void>()
        var tapMyRunning = PublishSubject<Void>()
        var bookMark = PublishSubject<Int>()
        var attend = PublishSubject<Int>()
        var toMain = PublishSubject<Void>()
        var writePost = PublishSubject<Void>()
        var changePhoto = PublishSubject<Void>()
        var photoSelected = PublishSubject<Data?>()
        var manageAttendance = PublishSubject<Int>()
        var changeToDefaultProfile = PublishSubject<Void>()
        var registerRunningPace = PublishSubject<Void>()

        var tapWriteLog = PublishSubject<Int>()
        var tapConfirmLog = PublishSubject<Int>()
        var tapManageAttendance = PublishSubject<Int>()
        var tapConfirmAttendance = PublishSubject<Int>()

        var logStampDidEndDecelerating = PublishSubject<Int>()
    }

    struct Output {
        var postType: PostType = .attendable
        var userInfo = ReplaySubject<UserConfig>.create(bufferSize: 1)
        var posts = ReplaySubject<[PostConfig]>.create(bufferSize: 1)
        var logStamps = ReplaySubject<[MyLogStampSection]>.create(bufferSize: 1)
        var logTotalCount = ReplaySubject<LogTotalCount>.create(bufferSize: 1)
        var attend = PublishSubject<(type: PostType, idx: Int, state: ParticipateAttendState)>()
        var profileChanged = PublishSubject<Data?>()
        var currentProfile = ReplaySubject<String?>.create(bufferSize: 1)
        var showPicker = PublishSubject<EditProfileType>()
        var days = ReplaySubject<[MyLogStampSection]>.create(bufferSize: 1)
        var changeTargetDate = ReplaySubject<(year: Int, month: Int)>.create(bufferSize: 1)
    }

    struct Route {
        var calendar = PublishSubject<Int>()
        var myRunningList = PublishSubject<Void>()
        var detailPost = PublishSubject<Int>()
        var needUpdates = PublishSubject<Void>()
        var editInfo = PublishSubject<User>()
        var settings = PublishSubject<String>()
        var writePost = PublishSubject<Void>()
        var toMain = PublishSubject<Void>()
        var photoModal = PublishSubject<Void>()
        var registerRunningPace = PublishSubject<Void>()

        var writeLog = PublishSubject<LogForm>()
        var confirmLog = PublishSubject<Int>()
        var manageAttendance = PublishSubject<Int>()
        var confirmAttendance = PublishSubject<Int>()
    }

    struct RouteInput {
        var needUpdate = ReplaySubject<Bool>.create(bufferSize: 1)
        var photoTypeSelected = PublishSubject<EditProfileType?>()
    }

    var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}

// MARK: - 날짜 계산

extension MyPageViewModel {
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
