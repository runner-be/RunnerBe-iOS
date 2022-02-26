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

    init(postId: Int, postAPIService: PostAPIService) {
        self.postAPIService = postAPIService
        super.init()

        postAPIService.detailInfo(postId: postId)
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
                            running: PostDetailRunningConfig(from: post),
                            participants: participants.reduce(into: [PostDetailUserConfig]()) {
                                $0.append(PostDetailUserConfig(from: $1, owner: post.writerID == $1.userID))
                            }
                        )
                    )
                    self.outputs.bookMarked.onNext(marked)
                    self.outputs.apply.onNext(apply)
                case let .writer(post, marked, participants, applicant):
                    self.outputs.detailData.onNext(
                        (
                            running: PostDetailRunningConfig(from: post),
                            participants: participants.reduce(into: [PostDetailUserConfig]()) {
                                $0.append(PostDetailUserConfig(from: $1, owner: post.writerID == $1.userID))
                            }
                        )
                    )
                    self.outputs.applicants.onNext(
                        applicant.reduce(into: [PostDetailUserConfig]()) {
                            $0.append(PostDetailUserConfig(from: $1, owner: false))
                        }
                    )
                    self.outputs.bookMarked.onNext(marked)
                default: break
                }

            })
            .disposed(by: disposeBag)

        inputs.backward
            .bind(to: routes.backward)
            .disposed(by: disposeBag)
    }

    struct Input {
        var backward = PublishSubject<Void>()
        var report = PublishSubject<Void>()
    }

    struct Output {
        var detailData = ReplaySubject<(running: PostDetailRunningConfig, participants: [PostDetailUserConfig])>.create(bufferSize: 1)
        var applicants = ReplaySubject<[PostDetailUserConfig]>.create(bufferSize: 1)
        var bookMarked = PublishSubject<Bool>()
        var apply = PublishSubject<Bool>()
    }

    struct Route {
        var backward = PublishSubject<Void>()
        var report = PublishSubject<Int>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
