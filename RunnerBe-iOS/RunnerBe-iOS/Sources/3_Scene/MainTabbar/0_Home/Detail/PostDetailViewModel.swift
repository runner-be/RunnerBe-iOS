//
//  PostDetailViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/25.
//

import Foundation
import RxSwift

final class PostDetailViewModel: BaseViewModel {
    private let postAPIService: PostAPIService
    private var marked: Bool = false
    private var applicants: [User] = []
    var anyChanged = false

    init(postId: Int, postAPIService: PostAPIService) {
        self.postAPIService = postAPIService
        super.init()

        postAPIService.detailInfo(postId: postId)
            .take(1)
            .do(onNext: {
                switch $0 {
                case .error:
                    // TODO: 에러처리
                    break
                default: return
                }
            }).subscribe(onNext: { [weak self] result in
                guard let self = self else { return }

                switch result {
                case let .guest(post, marked, apply, participants):
                    self.outputs.detailData.onNext(
                        (
                            finished: post.whetherEnd == "Y",
                            writer: false, applied: apply,
                            running: PostDetailRunningConfig(from: post),
                            participants: participants.reduce(into: [UserConfig]()) {
                                $0.append(UserConfig(from: $1, owner: post.writerID == $1.userID))
                            }
                        )
                    )
                    self.marked = marked
                    self.outputs.bookMarked.onNext(marked)
                    self.outputs.apply.onNext(apply)
                case let .writer(post, marked, participants, applicant):
                    self.outputs.detailData.onNext(
                        (
                            finished: post.whetherEnd == "Y",
                            writer: true, applied: false,
                            running: PostDetailRunningConfig(from: post),
                            participants: participants.reduce(into: [UserConfig]()) {
                                $0.append(UserConfig(from: $1, owner: post.writerID == $1.userID))
                            }
                        )
                    )
                    self.applicants = applicant
                    self.marked = marked
                    self.outputs.bookMarked.onNext(marked)
                default: break
                }
            })
            .disposed(by: disposeBag)

        routeInputs.needUpdate
            .flatMap { postAPIService.detailInfo(postId: postId) }
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }

                switch result {
                case let .guest(post, marked, apply, participants):
                    self.outputs.detailData.onNext(
                        (
                            finished: post.whetherEnd == "Y",
                            writer: false, applied: apply,
                            running: PostDetailRunningConfig(from: post),
                            participants: participants.reduce(into: [UserConfig]()) {
                                $0.append(UserConfig(from: $1, owner: post.writerID == $1.userID))
                            }
                        )
                    )
                    self.marked = marked
                    self.outputs.bookMarked.onNext(marked)
                    self.outputs.apply.onNext(apply)
                case let .writer(post, marked, participants, applicant):
                    self.outputs.detailData.onNext(
                        (
                            finished: post.whetherEnd == "Y",
                            writer: true, applied: false,
                            running: PostDetailRunningConfig(from: post),
                            participants: participants.reduce(into: [UserConfig]()) {
                                $0.append(UserConfig(from: $1, owner: post.writerID == $1.userID))
                            }
                        )
                    )
                    self.applicants = applicant
                    self.marked = marked
                    self.outputs.bookMarked.onNext(marked)
                default: break
                }
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

        inputs.showApplicant
            .compactMap { [weak self] _ in
                self?.applicants
            }
            .subscribe(routes.applicantsModal)
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
        var detailData = ReplaySubject<(finished: Bool, writer: Bool, applied: Bool, running: PostDetailRunningConfig, participants: [UserConfig])>.create(bufferSize: 1)
        var bookMarked = PublishSubject<Bool>()
        var apply = PublishSubject<Bool>()
        var toast = PublishSubject<String>()
        var finished = PublishSubject<Bool>()
    }

    struct Route {
        var backward = PublishSubject<(id: Int, marked: Bool, needUpdate: Bool)>()
        var report = PublishSubject<Int>()
        var applicantsModal = PublishSubject<[User]>()
    }

    struct RouteInput {
        var needUpdate = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
