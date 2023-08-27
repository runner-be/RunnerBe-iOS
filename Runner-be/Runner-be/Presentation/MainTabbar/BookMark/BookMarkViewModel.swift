//
//  BookMarkViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import RxSwift

final class BookMarkViewModel: BaseViewModel {
    private var runningTag: RunningTag = .beforeWork
    private let postUseCase = PostUseCase()

    var posts: [RunningTag: [Post]] = [
        .afterWork: [],
        .beforeWork: [],
        .dayoff: [],
        .error: [],
    ]

    override init() {
        super.init()

        uiBusinessLogic()
        requestDataToRepo()
    }

    // MARK: - INPUT, OUTPUT Modeling

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

// MARK: - Repository와 소통

extension BookMarkViewModel {
    func requestDataToRepo() {
        routeInputs.needUpdate
            .flatMap { _ in
                self.postUseCase.fetchPostBookMarked()
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

                    if let posts = self.posts[self.runningTag] {
                        self.outputs.posts.onNext(posts.map { PostCellConfig(from: $0) }) // onNext -> 값 추가 -> event 발생
                    } else {
                        self.outputs.posts.onNext([])
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UI 관련 비즈니스 로직

extension BookMarkViewModel {
    func uiBusinessLogic() {
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
}
