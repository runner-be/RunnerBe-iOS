//
//  PostDetailViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/25.
//

import Foundation
import RxSwift

final class PostDetailViewModel: BaseViewModel {
//    private var marked: Bool = false
    private var isWriter: Bool = false
    private var applicants: [User] = []
    private var participants: [User] = []
    private var roomID: Int?
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
                    let satisfied = (postDetail.post.gender == .none || postDetail.post.gender == userKeyChainService.gender)
                        && participants.count < postDetail.maximumNum

                    self.outputs.detailData.onNext(
                        (
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
//                    self.marked = marked
//                    self.outputs.bookMarked.onNext(marked)
//                    self.outputs.apply.onNext(apply)
                case let .writer(postDetail, marked, participants, applicant, roomID):
                    self.isWriter = true
                    self.roomID = roomID
                    self.outputs.detailData.onNext(
                        (
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
//                    self.marked = marked
//                    self.outputs.bookMarked.onNext(marked)
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
                        self?.outputs.toast.onNext(alertMessage)
                    } else {
                        self?.outputs.toast.onNext("데이터 불러오기에 실패했습니다.")
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
                        self?.outputs.toast.onNext(alertMessage)
                    } else {
                        self?.outputs.toast.onNext("데이터 불러오기에 실패했습니다.")
                    }
                    self?.routes.backward.onNext((id: postId, needUpdate: false))
                }
            })
            .disposed(by: disposeBag)

        inputs.backward
            .map { [unowned self] in (id: postId, needUpdate: self.anyChanged) }
            .bind(to: routes.backward)
            .disposed(by: disposeBag)

//        inputs.bookMark
//            .flatMap {
//                postAPIService.bookmark(postId: postId, mark: $0)
//            }
//            .subscribe(onNext: { [weak self] result in
//                guard let self = self
//                else { return }
//
//                self.marked = result.mark
//                self.outputs.bookMarked.onNext(result.mark)
//                self.anyChanged = true
//            })
//            .disposed(by: disposeBag)

        inputs.apply
            .flatMap {
                postAPIService.apply(postId: postId)
            }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .response:
                    self?.outputs.apply.onNext(true)
                    self?.outputs.toast.onNext("신청을 완료했습니다!")

                case let .error(alertMessage):
                    self?.outputs.apply.onNext(false)
                    if let alertMessage = alertMessage {
                        self?.outputs.toast.onNext(alertMessage)
                    } else {
                        self?.outputs.toast.onNext("신청에 실패했습니다")
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
                    self.outputs.toast.onNext(message)
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

        routeInputs.deleteOption
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if self.isWriter, self.applicants.isEmpty, self.participants.count < 2 {
                    self.routes.deleteConfirm.onNext(())
                } else {
                    self.outputs.toast.onNext("모임인원이 있어 삭제할 수 없습니다.")
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
                        self?.outputs.toast.onNext(alertMessage)
                    } else {
                        self?.outputs.toast.onNext("삭제에 실패했습니다.")
                    }
                }
            })
            .disposed(by: disposeBag)

        routeInputs.report
            .subscribe(onNext: { [weak self] report in
                if report {
                    self?.outputs.toast.onNext("신고가 접수되었습니다.")
                }
            })
            .disposed(by: disposeBag)

        inputs.toMessage
            .map { [weak self] in self?.roomID }
            .subscribe(onNext: { [weak self] roomID in
                if let roomID = roomID {
                    self?.routes.message.onNext(roomID)
                } else {
                    self?.outputs.toast.onNext("채팅방을 찾을 수 없습니다.")
                }
            })
            .disposed(by: disposeBag)
    }

    struct Input {
        var backward = PublishSubject<Void>()
        var rightOptionItem = PublishSubject<Void>()

//        var bookMark = PublishSubject<Bool>()
        var toMessage = PublishSubject<Void>()
        var apply = PublishSubject<Void>()
        var finishing = PublishSubject<Void>()
        var showApplicant = PublishSubject<Void>()
    }

    struct Output {
        var detailData = ReplaySubject<(finished: Bool, writer: Bool, participated: Bool, satisfied: Bool, applied: Bool, running: PostDetailRunningConfig, participants: [UserConfig], numApplicant: Int)>.create(bufferSize: 1)
//        var bookMarked = PublishSubject<Bool>()
        var apply = PublishSubject<Bool>()
        var toast = PublishSubject<String>()
        var finished = PublishSubject<Bool>()
    }

    struct Route {
        var backward = PublishSubject<(id: Int, needUpdate: Bool)>()
        var moreOption = PublishSubject<Void>()
        var deleteConfirm = PublishSubject<Void>()
        var report = PublishSubject<Void>()
        var applicantsModal = PublishSubject<[User]>()
        var message = PublishSubject<Int>()
    }

    struct RouteInput {
        var needUpdate = PublishSubject<Void>()
        var report = PublishSubject<Bool>()
        var deleteOption = PublishSubject<Void>()
        var delete = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
