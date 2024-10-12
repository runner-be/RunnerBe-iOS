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
    var posts = [PostType: [Post]]()
    private var myRunningLogs: [MyRunningLog?] = []

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
        logAPIService: LogAPIService = BasicLogAPIService()
    ) {
        super.init()

        outputs.changeTargetDate.onNext((
            year: targetYear,
            month: targetMonth
        ))

        routeInputs.needUpdate
            .filter { $0 }
            .flatMap { _ in logAPIService.fetchLog(targetDate: Date()) }
            .compactMap { [weak self] result -> LogResponse? in
                switch result {
                case let .response(data):
                    if let data = data {
                        return data
                    }
                    self?.toast.onNext("로그 스탬프 조회에 실패했습니다.")
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    }
                    return nil
                }
                return nil
            }
            .subscribe(onNext: { [weak self] logResponse in
                self?.outputs.logTotalCount.onNext(logResponse.totalCount)
                self?.changeTargetDate(runningLog: logResponse.myRunningLog)
            })
            .disposed(by: disposeBag)

        routeInputs.needUpdate
            .filter { $0 }
            .flatMap { _ in postAPIService.myPage() }
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.posts.removeAll()
                self.outputs.posts.onNext([])

                switch result {
                case let .response(result: data):
                    switch data {
                    case let .success(info, posting, joined):
                        let now = DateUtil.shared.now
                        self.user = info
                        // FIXME: postings 사용하지 않음, 마이페이지에서는 참여한 러닝만 포함하고 있기 때문
                        let postings = posting.sorted(by: { $0.gatherDate > $1.gatherDate })
                        let joins = joined.sorted(by: { $0.gatherDate > $1.gatherDate })

                        self.posts[.myPost] = postings
                        self.posts[.attendable] = joins

                        self.user = info
                        self.outputs.userInfo.onNext(UserConfig(from: info, owner: false))
                        self.outputs.posts.onNext(joins.map { MyPagePostConfig(post: $0, now: now) })
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

        inputs.typeChanged
            .filter { [unowned self] type in
                type != self.outputs.postType
            }
            .map { [unowned self] type -> [Post] in
                self.outputs.postType = type
                return self.posts[type] ?? []
            }
            .map { posts -> [MyPagePostConfig] in
                let now = DateUtil.shared.now
                return posts.reduce(into: [MyPagePostConfig]()) { $0.append(MyPagePostConfig(post: $1, now: now)) }
            }
            .subscribe(onNext: { [unowned self] postConfigs in
                self.outputs.posts.onNext(postConfigs)
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

                return self.myRunningLogs[logItemIndex]?.logId
            }
            .bind(to: routes.confirmLog)
            .disposed(by: disposeBag)

        // 스탬프 클릭 시 스탬프가 없으면 개인 로그 작성 페이지로 이동
        inputs.tapLogStamp
            .compactMap { [weak self] indexPath in
                // 1주 단위로 section으로 구분되어 있습니다.
                let section = indexPath.section * 7
                let item = indexPath.item
                let logItemIndex = section + item
                guard let self = self,
                      let myRunningLog = self.myRunningLogs[logItemIndex],
                      myRunningLog.logId == nil,
                      myRunningLog.isFuture == false
                else {
                    return nil
                }

                let runnedDate = myRunningLog.runnedDate
                if let runDate = runnedDate.toDate() {
                    return LogForm(
                        runningDate: runDate,
                        gatheringId: self.myRunningLogs[logItemIndex]?.gatheringId,
                        isOpened: 1
                    )
                }
                return nil
            }
            .bind(to: routes.writeLog)
            .disposed(by: disposeBag)

        inputs.tapLogStampIcon
            .bind(to: routes.calendar)
            .disposed(by: disposeBag)

        inputs.tapMyRunning
            .bind(to: routes.myRunningList)
            .disposed(by: disposeBag)

        inputs.tapPost
            .compactMap { [weak self] idx in
                guard let self = self,
                      let posts = self.posts[self.outputs.postType],
                      idx >= 0, idx < posts.count
                else {
                    self?.toast.onNext("해당 포스트를 여는데 실패했습니다.")
                    return nil
                }

                if Date().timeIntervalSince1970 < posts[idx].gatherDate.timeIntervalSince1970, self.posts[self.outputs.postType]?[idx].writerID == BasicLoginKeyChainService.shared.userId! { // 리더이면서 아직 시작안했을 때
                    self.toast.onNext("모임이 시작되면 출석을 체크할 수 있어요!")
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
                      let posts = self.posts[self.outputs.postType],
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
                      let posts = self.posts[self.outputs.postType],
                      let idx = posts.firstIndex(where: { $0.ID == result.postId })
                else {
                    self?.toast.onNext("북마크를 실패했습니다.")
                    return
                }

                self.posts[self.outputs.postType]![idx].marked = result.mark
                self.outputs.marked.onNext((
                    type: self.outputs.postType,
                    idx: idx,
                    marked: result.mark
                ))
            })
            .disposed(by: disposeBag)

        inputs.attend
            .compactMap { [weak self] idx -> Post? in
                guard let self = self,
                      let posts = self.posts[self.outputs.postType],
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
                          let posts = self.posts[self.outputs.postType],
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

        inputs.manageAttendance
            .bind(to: routes.manageAttendance)
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
                guard let self = self,
                      let selectedPost = self.posts[.attendable]?[itemIndex]
                else {
                    return nil
                }

                return LogForm(
                    runningDate: selectedPost.gatherDate,
                    logId: selectedPost.ID,
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
                guard let self = self,
                      let selectedPost = self.posts[.attendable]?[itemIndex]
                else {
                    return nil
                }

                return selectedPost.ID
            }
            .bind(to: routes.confirmLog)
            .disposed(by: disposeBag)

        inputs.tapManageAttendance
            .compactMap { [weak self] index in
                guard let self = self else { return nil }
                return posts[outputs.postType]?[index].ID
            }
            .bind(to: routes.manageAttendance)
            .disposed(by: disposeBag)

        inputs.tapConfirmAttendance
            .compactMap { [weak self] index in
                guard let self = self else { return nil }
                return posts[outputs.postType]?[index].ID
            }
            .bind(to: routes.confirmAttendance)
            .disposed(by: disposeBag)
    }

    // MARK: - Methods

    private func changeTargetDate(runningLog: [MyRunningLog]) {
        myRunningLogs.removeAll()
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

            for log in runningLog {
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

            myRunningLogs.append(MyRunningLog(
                logId: logId,
                gatheringId: gatheringId,
                runnedDate: date.description,
                stampCode: stampType?.rawValue
            ))

            return MyLogStampConfig(from: LogStamp(
                logId: logId,
                gatheringId: gatheringId,
                date: date,
                stampType: stampType
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
    }

    struct Output {
        var postType: PostType = .attendable
        var userInfo = ReplaySubject<UserConfig>.create(bufferSize: 1)
        var posts = ReplaySubject<[MyPagePostConfig]>.create(bufferSize: 1)
        var logStamps = ReplaySubject<[MyLogStampSection]>.create(bufferSize: 1)
        var logTotalCount = ReplaySubject<LogTotalCount>.create(bufferSize: 1)
        var marked = PublishSubject<(type: PostType, idx: Int, marked: Bool)>()
        var attend = PublishSubject<(type: PostType, idx: Int, state: ParticipateAttendState)>()
        var profileChanged = PublishSubject<Data?>()
        var currentProfile = ReplaySubject<String?>.create(bufferSize: 1)
        var showPicker = PublishSubject<EditProfileType>()
        var days = ReplaySubject<[MyLogStampConfig]>.create(bufferSize: 1)
        var changeTargetDate = ReplaySubject<(year: Int, month: Int)>.create(bufferSize: 1)
    }

    struct Route {
        var calendar = PublishSubject<Void>()
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
