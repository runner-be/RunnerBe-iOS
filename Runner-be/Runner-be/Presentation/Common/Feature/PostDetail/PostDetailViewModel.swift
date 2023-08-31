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
    var anyChanged = false
    var postId = -1

    private let postUseCase = PostUseCase()
    private let userUseCase = UserUseCase()
    private let loginUseCase = LoginUseCase()

    init(postId: Int) {
        self.postId = postId
        super.init()

        requestDataToUseCase()
        uiBusinessLogic()
    }

    struct Input {
        var backward = PublishSubject<Void>()
        var rightOptionItem = PublishSubject<Void>()
        var toMessage = PublishSubject<Void>()
        var apply = PublishSubject<Void>()
        var finishing = PublishSubject<Void>()
        var showApplicant = PublishSubject<Void>()
        var postDetailInfoReady = ReplaySubject<DetailInfoResult>.create(bufferSize: 1)
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

extension PostDetailViewModel {
    func requestDataToUseCase() {
        postUseCase.detailInfo(postId: postId)
            .take(1)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }

                switch result {
                case let .response(data):
                    self.inputs.postDetailInfoReady.onNext(data)
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self.toast.onNext(alertMessage)
                    } else {
                        self.toast.onNext("데이터 불러오기에 실패했습니다.")
                    }
                    self.routes.backward.onNext((id: self.postId, needUpdate: false))
                }
            })
            .disposed(by: disposeBag)

        routeInputs.needUpdate
            .flatMap { self.postUseCase.detailInfo(postId: self.postId) }
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }

                switch result {
                case let .response(data):
                    self.inputs.postDetailInfoReady.onNext(data)
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self.toast.onNext(alertMessage)
                    } else {
                        self.toast.onNext("데이터 불러오기에 실패했습니다.")
                    }
                    self.routes.backward.onNext((id: self.postId, needUpdate: false))
                }
            })
            .disposed(by: disposeBag)

        inputs.apply
            .flatMap {
                self.postUseCase.apply(postId: self.postId)
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
                self.postUseCase.close(postId: self.postId)
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

        routeInputs.delete
            .flatMap {
                self.postUseCase.delete(postId: self.postId)
            }
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .response:
                    self.routes.backward.onNext((id: self.postId, needUpdate: true))
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self.toast.onNext(alertMessage)
                    } else {
                        self.toast.onNext("삭제에 실패했습니다.")
                    }
                }
            })
            .disposed(by: disposeBag)

        routeInputs.report
            .filter { $0 }
            .flatMap { _ in
                self.postUseCase.report(postId: self.postId)
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
    }

    func uiBusinessLogic() {
        inputs.postDetailInfoReady
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }

                switch result {
                case let .guest(postDetail, participated, _, apply, participants, roomID):
                    self.isWriter = false
                    self.roomID = roomID
                    let satisfied = (postDetail.post.gender == .none || postDetail.post.gender == self.userUseCase.gender)
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
                case let .writer(postDetail, _, participants, applicant, roomID):
                    self.isWriter = true
                    self.roomID = roomID
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

        inputs.backward
            .map { [unowned self] in (id: postId, needUpdate: self.anyChanged) }
            .bind(to: routes.backward)
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
                    self.toast.onNext("모임인원이 있어 삭제할 수 없습니다.")
                }
            })
            .disposed(by: disposeBag)
    }
}
