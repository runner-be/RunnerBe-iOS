//
//  BookMarkViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import RxSwift

final class BookMarkViewModel: BaseViewModel {
    private var runningTag: RunningTag = .all

    var posts: [RunningTag: [Post]] = [
        .all: [],
        .afterWork: [],
        .beforeWork: [],
        .dayoff: [],
        .error: [],
    ]

    init(postAPIService: PostAPIService = BasicPostAPIService()) {
        super.init()

        routeInputs.needUpdate
            .flatMap { _ in
                postAPIService.fetchPostsBookMarked()
            }
            .map { [weak self] result -> [Post]? in
                switch result {
                case let .response(result: data):
                    return data
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    }
                    return nil
                }
            }
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.posts.removeAll()

                if let result = result {
                    self.posts = result.reduce(into: [RunningTag: [Post]]()) {
                        let runningTag = $1.tag
                        var post = $1
                        post.marked = true
                        $0[runningTag, default: []].append(post)
                    }
                    self.posts[.all, default: []].append(contentsOf: result) // 전체 조회 시 result 추가

                    if let posts = self.posts[self.runningTag] {
                        self.outputs.posts.onNext(posts.map { PostCellConfig(from: $0) })
                    } else {
                        self.outputs.posts.onNext([])
                    }
                }
            })
            .disposed(by: disposeBag)

        inputs.tagChanged
            .subscribe(onNext: { [weak self] tagIdx in
                guard let self = self else { return }
                let newTag = RunningTag(idx: tagIdx)
                self.runningTag = newTag
                if newTag != .error {
                    let posts = self.posts[newTag, default: []].map { PostCellConfig(from: $0) }
                    self.outputs.posts.onNext(posts)
                }
            })
            .disposed(by: disposeBag)

        inputs.tapPostBookMark
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .compactMap { [weak self] idx -> Post? in
                guard let self = self,
                      let posts = self.posts[self.runningTag],
                      idx >= 0, idx < posts.count
                else { return nil }
                return posts[idx]
            }
            .flatMap { postAPIService.bookmark(postId: $0.ID, mark: !$0.marked) }
            .subscribe(onNext: { [weak self] result in
                guard let self = self,
                      var posts = self.posts[self.runningTag]
                else { return }

                switch result {
                case let .response(data):
                    if let idx = posts.firstIndex(where: { $0.ID == data.postId }) {
                        if !data.mark {
                            posts.remove(at: idx)
                            self.posts[self.runningTag] = posts
                            self.outputs.posts.onNext(posts.map { PostCellConfig(from: $0) })
                        }
                    }
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self.toast.onNext(alertMessage)
                    }
                }
            })
            .disposed(by: disposeBag)

        inputs.tapPost
            .subscribe(onNext: { [weak self] idx in
                guard let self = self,
                      let posts = self.posts[self.runningTag],
                      idx >= 0, idx < posts.count
                else {
                    return
                }
                self.routes.detailPost.onNext(posts[idx].ID)
            })
            .disposed(by: disposeBag)
    }

    struct Input {
        var tagChanged = PublishSubject<Int>()
        var tapPostBookMark = PublishSubject<Int>()
        var tapPost = PublishSubject<Int>()
    }

    struct Output {
        var posts = ReplaySubject<[PostCellConfig]>.create(bufferSize: 1)
        var toast = BehaviorSubject<String>(value: "")
    }

    struct Route {
        var detailPost = PublishSubject<Int>()
        var needUpdates = PublishSubject<Void>()
    }

    struct RouteInput {
        var needUpdate = PublishSubject<Bool>()
    }

    var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
