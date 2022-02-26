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
                            running: RunningInfo(from: post),
                            participants: participants.reduce(into: [UserInfo]()) {
                                $0.append(UserInfo(from: $1, owner: post.writerID == $1.userID))
                            }
                        )
                    )
                    self.outputs.bookMarked.onNext(marked)
                    self.outputs.apply.onNext(apply)
                case let .writer(post, marked, participants, applicant):
                    self.outputs.detailData.onNext(
                        (
                            running: RunningInfo(from: post),
                            participants: participants.reduce(into: [UserInfo]()) {
                                $0.append(UserInfo(from: $1, owner: post.writerID == $1.userID))
                            }
                        )
                    )
                    self.outputs.applicants.onNext(
                        applicant.reduce(into: [UserInfo]()) {
                            $0.append(UserInfo(from: $1, owner: false))
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
        var detailData = ReplaySubject<(running: RunningInfo, participants: [UserInfo])>.create(bufferSize: 1)
        var applicants = ReplaySubject<[UserInfo]>.create(bufferSize: 1)
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

struct RunningInfo {
    let badge: String
    let title: String
    let placeInfo: String
    let date: String
    let time: String
    let gender: String
    let age: String
    let numParticipant: String
    let long: Float
    let lat: Float
    let range: Float
    let contents: String
}

extension RunningInfo {
    init(from post: Post) {
        badge = post.runningTag
        title = post.title
        placeInfo = post.locationInfo
        time = post.runningTime
        gender = post.gender.name
        age = "\(post.minAge)-\(post.maxAge)"
        date = post.gatheringTime
        numParticipant = String(post.numParticipantsLimit)
        long = post.longitude
        lat = post.latitude
        range = 1000
        contents = post.contents
    }
}

struct UserInfo {
    let nickName: String
    let age: String
    let gender: String
    let job: String
    let isPostOwner: Bool

    init(from user: User, owner: Bool) {
        nickName = user.nickName
        age = user.age
        gender = user.gender
        job = user.job
        isPostOwner = owner
    }
}
