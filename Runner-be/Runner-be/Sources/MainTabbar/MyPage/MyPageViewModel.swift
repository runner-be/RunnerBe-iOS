//
//  MyPageViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import RxSwift

final class MyPageViewModel: BaseViewModel {
    var dirty: Bool = false

    enum PostType {
        case myPost, attendable
    }

    var user: User?
    var posts = [PostType: [Post]]()

    init(postAPIService: PostAPIService = BasicPostAPIService(), userAPIService: UserAPIService = BasicUserAPIService()) {
        super.init()

        let allItems = [
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 12, isToday: false)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "화", date: 13, isToday: false)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "수", date: 14, isToday: false)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "목", date: 15, isToday: false)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "금", date: 16, isToday: false)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "토", date: 17, isToday: false)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "일", date: 18, isToday: false)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 19, isToday: false)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "화", date: 20, isToday: false)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "수", date: 21, isToday: false)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "목", date: 22, isToday: false)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "금", date: 23, isToday: false)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "토", date: 24, isToday: false)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "일", date: 25, isToday: false)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "월", date: 26, isToday: false)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "화", date: 27, isToday: false)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "수", date: 28, isToday: true)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "목", date: 29, isToday: false)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "금", date: 30, isToday: false)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "토", date: 31, isToday: false)),
            MyLogStampConfig(from: LogStamp(dayOfWeek: "일", date: 1, isToday: false)),
        ]

        // 7개씩 끊어서 섹션 만들기
        let sections = stride(from: 0, to: allItems.count, by: 7).map { startIndex -> MyLogStampSection in
            let endIndex = min(startIndex + 7, allItems.count)
            let items = Array(allItems[startIndex ..< endIndex])
            return MyLogStampSection(items: items)
        }

        // ViewModel Output에 섹션 전달
        outputs.logStamps.onNext(sections)

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
                        let postings = posting.sorted(by: { $0.gatherDate > $1.gatherDate })
                        let joins = joined.sorted(by: { $0.gatherDate > $1.gatherDate })

                        self.posts[.myPost] = postings
                        self.posts[.attendable] = joins

                        let posts = self.outputs.postType == .myPost ? postings : joins
                        self.user = info
                        self.outputs.userInfo.onNext(UserConfig(from: info, owner: false))
                        self.outputs.posts.onNext(posts.map { MyPagePostConfig(post: $0, now: now) })
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

        inputs.tapLogStamp
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
                self.outputs.marked.onNext((type: self.outputs.postType, idx: idx, marked: result.mark))
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
                    gatheringId: selectedPost.ID,
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

                return LogForm(
                    runningDate: selectedPost.gatherDate,
                    gatheringId: selectedPost.ID,
                    stampCode: nil,
                    contents: nil,
                    imageUrl: nil,
                    weatherDegree: nil,
                    weatherIcon: nil,
                    isOpened: 1
                )
            }
            .bind(to: routes.confirmLog)
            .disposed(by: disposeBag)

        inputs.tapManageAttendance
            .bind(to: routes.manageAttendance)
            .disposed(by: disposeBag)

        inputs.tapConfirmAttendance
            .bind(to: routes.confirmAttendance)
            .disposed(by: disposeBag)
    }

    struct Input {
        var typeChanged = PublishSubject<PostType>() // subscribe 된 시점 이후부터 발생한 이벤트를 전달
        var settings = PublishSubject<Void>()
        var editInfo = PublishSubject<Void>()
        var tapPost = PublishSubject<Int>()
        var tapLogStamp = PublishSubject<Int>()
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
        var marked = PublishSubject<(type: PostType, idx: Int, marked: Bool)>()
        var attend = PublishSubject<(type: PostType, idx: Int, state: ParticipateAttendState)>()
        var profileChanged = PublishSubject<Data?>()
        var currentProfile = ReplaySubject<String?>.create(bufferSize: 1)
        var showPicker = PublishSubject<EditProfileType>()
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
        var confirmLog = PublishSubject<LogForm>()
        var manageAttendance = PublishSubject<Int>()
        var confirmAttendance = PublishSubject<Int>()
    }

    struct RouteInput {
        var needUpdate = PublishSubject<Bool>()
        var photoTypeSelected = PublishSubject<EditProfileType?>()
    }

    var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
