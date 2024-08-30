//
//  MyRunningListViewModel.swift
//  Runner-be
//
//  Created by 김창규 on 8/29/24.
//

import Foundation
import RxSwift

final class MyRunningListViewModel: BaseViewModel {
    // MARK: - Properties

    enum PostType {
        case all, myPost
    }

    var posts = [PostType: [Post]]()

    // MARK: - Init

    init(postAPIService: PostAPIService = BasicPostAPIService()) {
        super.init()

        routeInputs.needUpdate
            .filter { $0 }
            .flatMap { _ in postAPIService.myPage() }
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.posts.removeAll()
                self.outputs.posts.onNext([])

                switch result {
                case let .response(result: data):
                    switch data {
                    case let .success(info, posting, joined):
                        let now = DateUtil.shared.now
                        let postings = posting.sorted(by: { $0.gatherDate > $1.gatherDate })
                        let joins = joined.sorted(by: { $0.gatherDate > $1.gatherDate })

                        self.posts[.all] = joins
                        self.posts[.myPost] = postings

                        let posts = self.outputs.postType == .all ? joins : postings

                        self.outputs.posts.onNext(posts.map {
                            MyPagePostConfig(post: $0, now: now)
                        })
                    }
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self.toast.onNext(alertMessage)
                    } else {
                        self.toast.onNext("불러오기에 실패했습니다.")
                    }
                }
            }).disposed(by: disposeBag)

        inputs.typeChanged
            .filter { [unowned self] type in
                type != self.outputs.postType
            }
            .map { [unowned self] type -> [Post] in
                self.outputs.postType = type
                return self.posts[type] ?? []
            }
            .map { posts -> [MyPagePostConfig] in
                let now = DateUtil.shared.now
                return posts.reduce(into: [MyPagePostConfig]()) { $0.append(MyPagePostConfig(post: $1, now: now)) }
            }
            .subscribe(onNext: { [unowned self] postConfigs in
                self.outputs.posts.onNext(postConfigs)
            })
            .disposed(by: disposeBag)

        inputs.tapWriteLog
            .bind(to: routes.writeLog)
            .disposed(by: disposeBag)
    }

    // MARK: - Methods

    struct Input {
        var typeChanged = PublishSubject<PostType>()
        var tapWriteLog = PublishSubject<Int>()
    }

    struct Output {
        var postType: PostType = .all
        var posts = ReplaySubject<[MyPagePostConfig]>.create(bufferSize: 1)
    }

    struct Route {
        var backward = PublishSubject<Void>()
        var writeLog = PublishSubject<Int>()
    }

    struct RouteInput {
        var needUpdate = PublishSubject<Bool>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
