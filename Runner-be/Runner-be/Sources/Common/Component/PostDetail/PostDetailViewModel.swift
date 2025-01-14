//
//  PostDetailViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/25.
//

import Foundation
import RxSwift

final class PostDetailViewModel: BaseViewModel {
    private var isWriter: Bool = false
    private var applicants: [User] = []
    private var participants: [User] = []
    private var roomID: Int?
    private var placeAddress: String?
    var anyChanged = false

    init(
        postId: Int,
        postAPIService: PostAPIService = BasicPostAPIService(),
        userKeyChainService: UserKeychainService = BasicUserKeyChainService.shared,
        loginKeyChainService _: LoginKeyChainService = BasicLoginKeyChainService.shared
    ) {
        super.init()

        let postDetailInfoReady = ReplaySubject<DetailInfoResult>.create(bufferSize: 1)
        postDetailInfoReady
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }

                switch result {
                case let .guest(postDetail, participated, marked, apply, participants, roomID):
                    self.isWriter = false
                    self.roomID = roomID
                    self.placeAddress = postDetail.post.placeName
                    let satisfied = (postDetail.post.gender == .none || postDetail.post.gender == userKeyChainService.gender)
                        && participants.count < postDetail.maximumNum

                    self.outputs.detailData.onNext(
                        (
                            postDetail: postDetail,
                            finished: !postDetail.post.open,
                            writer: false,
                            participated: participated,
                            satisfied: satisfied,
                            applied: apply,
                            running: PostDetailRunningConfig(from: postDetail),
                            participants: participants.reduce(into: [UserConfig]()) {
                                $0.append(UserConfig(from: $1, owner: postDetail.post.writerID == $1.userID))
                            },
                            numApplicant: 0
                        )
                    )
                case let .writer(postDetail, marked, participants, applicant, roomID):
                    self.isWriter = true
                    self.roomID = roomID
                    self.placeAddress = postDetail.post.placeName
                    self.outputs.detailData.onNext(
                        (
                            postDetail: postDetail,
                            finished: !postDetail.post.open,
                            writer: true,
                            participated: true,
                            satisfied: true,
                            applied: false,
                            running: PostDetailRunningConfig(from: postDetail),
                            participants: participants.reduce(into: [UserConfig]()) {
                                $0.append(UserConfig(from: $1, owner: postDetail.post.writerID == $1.userID))
                            },
                            numApplicant: applicant.count
                        )
                    )
                    self.applicants = applicant
                    self.participants = participants
                default: break
                }
            })
            .disposed(by: disposeBag)

        postAPIService.detailInfo(postId: postId)
            .take(1)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case let .response(data):
                    postDetailInfoReady.onNext(data)
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    } else {
                        self?.toast.onNext("데이터 불러오기에 실패했습니다.")
                    }
                    self?.routes.backward.onNext((id: postId, needUpdate: false))
                }
            })
            .disposed(by: disposeBag)

        routeInputs.needUpdate
            .flatMap { postAPIService.detailInfo(postId: postId) }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case let .response(data):
                    postDetailInfoReady.onNext(data)
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    } else {
                        self?.toast.onNext("데이터 불러오기에 실패했습니다.")
                    }
                    self?.routes.backward.onNext((id: postId, needUpdate: false))
                }
            })
            .disposed(by: disposeBag)

        inputs.backward
            .map { [unowned self] in (id: postId, needUpdate: self.anyChanged) }
            .bind(to: routes.backward)
            .disposed(by: disposeBag)

        inputs.apply
            .filter {
                if userKeyChainService.runningPace == .none {
                    self.routes.registerRunningPace.onNext(())
                    return false
                } else {
                    return true
                }
            }
            .flatMap {
                postAPIService.apply(postId: postId)
            }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .response:
                    self?.outputs.apply.onNext(true)
                    self?.toast.onNext("신청을 완료했습니다!")

                case let .error(alertMessage):
                    self?.outputs.apply.onNext(false)
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    } else {
                        self?.toast.onNext("신청에 실패했습니다")
                    }
                }
            })
            .disposed(by: disposeBag)

        inputs.finishing
            .flatMap {
                postAPIService.close(postId: postId)
            }
            .subscribe(onNext: { [weak self] result in
                guard let self = self
                else { return }

                let message: String?
                let success: Bool
                switch result {
                case .response:
                    message = "마감을 완료했습니다."
                    self.anyChanged = true
                    success = true
                case let .error(alertMessage):
                    message = alertMessage
                    success = false
                }

                if let message = message {
                    self.toast.onNext(message)
                }
                self.outputs.finished.onNext(success)
            })
            .disposed(by: disposeBag)

        inputs.showApplicant
            .compactMap { [weak self] _ in
                self?.applicants
            }
            .subscribe(routes.applicantsModal)
            .disposed(by: disposeBag)

        inputs.rightOptionItem
            .subscribe(onNext: { [unowned self] in
                if self.isWriter {
                    routes.moreOption.onNext(())
                } else {
                    routes.report.onNext(())
                }
            })
            .disposed(by: disposeBag)

        inputs.copyPlaceName
            .subscribe(onNext: { [weak self] _ in
                UIPasteboard.general.string = self?.placeAddress
                self?.toast.onNext("주소가 복사되었어요")
            }).disposed(by: disposeBag)

        routeInputs.deleteOption
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if self.isWriter, self.applicants.isEmpty, self.participants.count < 2 {
                    self.routes.deleteConfirm.onNext(())
                } else {
                    self.toast.onNext("모임인원이 있어 삭제할 수 없습니다.")
                }
            })
            .disposed(by: disposeBag)

        routeInputs.delete
            .flatMap {
                postAPIService.delete(postId: postId)
            }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .response:
                    self?.routes.backward.onNext((id: postId, needUpdate: true))
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    } else {
                        self?.toast.onNext("삭제에 실패했습니다.")
                    }
                }
            })
            .disposed(by: disposeBag)

        routeInputs.report
            .filter { $0 }
            .flatMap { _ in
                postAPIService.report(postId: postId)
            }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .response:
                    self?.toast.onNext("신고가 접수되었습니다.")
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    } else {
                        self?.toast.onNext("오류가 발생해 신고가 접수되지 않았습니다.")
                    }
                }
            })
            .disposed(by: disposeBag)

        inputs.toMessage
            .map { [weak self] in self?.roomID }
            .subscribe(onNext: { [weak self] roomID in
                if let roomID = roomID {
                    self?.routes.message.onNext(roomID)
                } else {
                    self?.toast.onNext("채팅방을 찾을 수 없습니다.")
                }
            })
            .disposed(by: disposeBag)

        inputs.tapProfile
            .bind(to: routes.userPage)
            .disposed(by: disposeBag)

        routeInputs.userPage
            .bind(to: routes.userPage)
            .disposed(by: disposeBag)
    }

    struct Input {
        var backward = PublishSubject<Void>()
        var rightOptionItem = PublishSubject<Void>()
        var toMessage = PublishSubject<Void>()
        var apply = PublishSubject<Void>()
        var finishing = PublishSubject<Void>()
        var showApplicant = PublishSubject<Void>()
        var copyPlaceName = PublishSubject<Void>()
        var tapProfile = PublishSubject<Int>()
    }

    struct Output {
        var detailData = ReplaySubject<(postDetail: PostDetail, finished: Bool, writer: Bool, participated: Bool, satisfied: Bool, applied: Bool, running: PostDetailRunningConfig, participants: [UserConfig], numApplicant: Int)>.create(bufferSize: 1)
        var apply = PublishSubject<Bool>()
        var finished = PublishSubject<Bool>()
    }

    struct Route {
        var backward = PublishSubject<(id: Int, needUpdate: Bool)>()
        var moreOption = PublishSubject<Void>()
        var deleteConfirm = PublishSubject<Void>()
        var report = PublishSubject<Void>()
        var applicantsModal = PublishSubject<[User]>()
        var message = PublishSubject<Int>()
        var registerRunningPace = PublishSubject<Void>()
        var userPage = PublishSubject<Int>()
    }

    struct RouteInput {
        var needUpdate = PublishSubject<Void>()
        var report = PublishSubject<Bool>()
        var deleteOption = PublishSubject<Void>()
        var delete = PublishSubject<Void>()
        var userPage = PublishSubject<Int>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
