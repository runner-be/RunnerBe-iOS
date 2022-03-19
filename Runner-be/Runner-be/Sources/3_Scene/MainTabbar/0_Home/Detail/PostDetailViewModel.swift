//
//  PostDetailViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/25.
//

import Foundation
import RxSwift

final class PostDetailViewModel: BaseViewModel {
    private let userKeyChainService: UserKeychainService
    private let postAPIService: PostAPIService
    private var marked: Bool = false
    private var applicants: [User] = []
    var anyChanged = false

    init(postId: Int, postAPIService: PostAPIService, userKeyChainService: UserKeychainService) {
        self.userKeyChainService = userKeyChainService
        self.postAPIService = postAPIService
        super.init()

        let postDetailInfoReady = ReplaySubject<DetailInfoResult>.create(bufferSize: 1)
        postDetailInfoReady
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }

                switch result {
                case let .guest(postDetail, participated, marked, apply, participants):
                    let satisfied = (postDetail.post.gender == .none || postDetail.post.gender == userKeyChainService.gender)
                    self.outputs.detailData.onNext(
                        (
                            finished: !postDetail.post.open,
                            writer: false, participated: participated, satisfied: satisfied, applied: apply,
                            running: PostDetailRunningConfig(from: postDetail),
                            participants: participants.reduce(into: [UserConfig]()) {
                                $0.append(UserConfig(from: $1, owner: postDetail.post.writerID == $1.userID))
                            },
                            numApplicant: 0
                        )
                    )
                    self.marked = marked
                    self.outputs.bookMarked.onNext(marked)
                    self.outputs.apply.onNext(apply)
                case let .writer(postDetail, marked, participants, applicant):
                    self.outputs.detailData.onNext(
                        (
                            finished: !postDetail.post.open,
                            writer: true, participated: true, satisfied: true, applied: false,
                            running: PostDetailRunningConfig(from: postDetail),
                            participants: participants.reduce(into: [UserConfig]()) {
                                $0.append(UserConfig(from: $1, owner: postDetail.post.writerID == $1.userID))
                            },
                            numApplicant: applicant.count
                        )
                    )
                    self.applicants = applicant
                    self.marked = marked
                    self.outputs.bookMarked.onNext(marked)
                default: break
                }
            })
            .disposed(by: disposeBag)

        postAPIService.detailInfo(postId: postId)
            .take(1)
            .subscribe(onNext: {
                postDetailInfoReady.onNext($0)
            })
            .disposed(by: disposeBag)

        routeInputs.needUpdate
            .flatMap { postAPIService.detailInfo(postId: postId) }
            .subscribe(onNext: {
                postDetailInfoReady.onNext($0)
            })
            .disposed(by: disposeBag)

        inputs.backward
            .map { [unowned self] in (id: postId, marked: self.marked, needUpdate: self.anyChanged) }
            .bind(to: routes.backward)
            .disposed(by: disposeBag)

        inputs.bookMark
            .flatMap {
                postAPIService.bookmark(postId: postId, mark: $0)
            }
            .subscribe(onNext: { [weak self] result in
                guard let self = self
                else { return }

                self.marked = result.mark
                self.outputs.bookMarked.onNext(result.mark)
                self.anyChanged = true
            })
            .disposed(by: disposeBag)

        inputs.apply
            .flatMap {
                postAPIService.apply(postId: postId)
            }
            .subscribe(onNext: { [weak self] success in
                guard let self = self
                else { return }
                let message: String
                if success {
                    message = "신청을 완료했습니다!"
                    self.outputs.apply.onNext(true)
                } else {
                    message = "신청에 실패했습니다!"
                    self.outputs.apply.onNext(false)
                }

                self.outputs.toast.onNext(message)
            })
            .disposed(by: disposeBag)

        inputs.finishing
            .flatMap {
                postAPIService.close(postId: postId)
            }
            .subscribe(onNext: { [weak self] success in
                guard let self = self
                else { return }
                let message: String
                if success {
                    message = "마감을 완료하였습니다!"
                    self.anyChanged = true
                } else {
                    message = "마감에 실패했습니다!"
                }

                self.outputs.finished.onNext(success)
                self.outputs.toast.onNext(message)
            })
            .disposed(by: disposeBag)

        inputs.showApplicant
            .compactMap { [weak self] _ in
                self?.applicants
            }
            .subscribe(routes.applicantsModal)
            .disposed(by: disposeBag)

        inputs.report
            .subscribe(routes.report)
            .disposed(by: disposeBag)

        routeInputs.report
            .subscribe(onNext: { [weak self] report in
                if report {
                    self?.outputs.toast.onNext("신고가 접수되었습니다.")
                }
            })
            .disposed(by: disposeBag)
    }

    struct Input {
        var backward = PublishSubject<Void>()
        var report = PublishSubject<Void>()

        var bookMark = PublishSubject<Bool>()
        var apply = PublishSubject<Void>()
        var finishing = PublishSubject<Void>()
        var showApplicant = PublishSubject<Void>()
    }

    struct Output {
        var detailData = ReplaySubject<(finished: Bool, writer: Bool, participated: Bool, satisfied: Bool, applied: Bool, running: PostDetailRunningConfig, participants: [UserConfig], numApplicant: Int)>.create(bufferSize: 1)
        var bookMarked = PublishSubject<Bool>()
        var apply = PublishSubject<Bool>()
        var toast = PublishSubject<String>()
        var finished = PublishSubject<Bool>()
    }

    struct Route {
        var backward = PublishSubject<(id: Int, marked: Bool, needUpdate: Bool)>()
        var report = PublishSubject<Void>()
        var applicantsModal = PublishSubject<[User]>()
    }

    struct RouteInput {
        var needUpdate = PublishSubject<Void>()
        var report = PublishSubject<Bool>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
