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
                            writer: false,
                            running: PostDetailRunningConfig(from: post),
                            participants: participants.reduce(into: [PostDetailUserConfig]()) {
                                $0.append(PostDetailUserConfig(from: $1, owner: post.writerID == $1.userID))
                            }
                        )
                    )
                    self.marked = marked
                    self.outputs.bookMarked.onNext(marked)
                    self.outputs.apply.onNext(apply)
                case let .writer(post, marked, participants, applicant):
                    self.outputs.detailData.onNext(
                        (
                            writer: true,
                            running: PostDetailRunningConfig(from: post),
                            participants: participants.reduce(into: [PostDetailUserConfig]()) {
                                $0.append(PostDetailUserConfig(from: $1, owner: post.writerID == $1.userID))
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
            .map { [unowned self] in (id: postId, marked: self.marked) }
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
                if !success {
                    message = "신청을 완료했습니다!"
                } else {
                    message = "신청에 실패했습니다!"
                }

                self.outputs.toast.onNext(message)
            })
            .disposed(by: disposeBag)

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
        var detailData = ReplaySubject<(writer: Bool, running: PostDetailRunningConfig, participants: [PostDetailUserConfig])>.create(bufferSize: 1)
        var bookMarked = PublishSubject<Bool>()
        var apply = PublishSubject<Bool>()
        var toast = PublishSubject<String>()
    }

    struct Route {
        var backward = PublishSubject<(id: Int, marked: Bool)>()
        var report = PublishSubject<Int>()
        var applicantsModal = PublishSubject<[User]>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
