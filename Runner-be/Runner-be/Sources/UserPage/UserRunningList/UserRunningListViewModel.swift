//
//  UserRunningListViewModel.swift
//  Runner-be
//
//  Created by 김창규 on 10/22/24.
//

import Foundation
import RxSwift

final class UserRunningListViewModel: BaseViewModel {
    // MARK: - Properties

    struct Input {
        var tapPost = PublishSubject<Int>()
    }

    struct Output {
        var nickName = PublishSubject<String>()
        var postCount = PublishSubject<Int>()
        var posts = ReplaySubject<[PostConfig]>.create(bufferSize: 1)
    }

    struct Route {
        var backward = PublishSubject<Void>()
        var detailPost = PublishSubject<Int>()
    }

    struct RouteInputs {
        var needUpdate = PublishSubject<Bool>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInputs()

    var posts = [Post]()

    // MARK: - Init

    init(
        userId: Int,
        userAPIService: UserAPIService = BasicUserAPIService()
    ) {
        super.init()

        userAPIService.userPage(userId: userId)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.posts.removeAll()
                self.outputs.posts.onNext([])

                switch result {
                case let .response(data):
                    switch data {
                    case let .success(userinfo, _, userRunning):
                        self.posts = userRunning
                        self.outputs.nickName.onNext(userinfo.nickName)
                        self.outputs.postCount.onNext(userRunning.count)
                        self.outputs.posts.onNext(posts.map { PostConfig(from: $0) })
                    }

                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self.toast.onNext(alertMessage)
                    } else {
                        self.toast.onNext("불러오기에 실패했습니다.")
                    }
                }
            }).disposed(by: disposeBag)

        inputs.tapPost
            .compactMap { [weak self] idx in
                guard let self = self,
                      idx >= 0, idx < self.posts.count
                else {
                    self?.toast.onNext("해당 포스트를 여는데 실패했습니다.")
                    return nil
                }

                print("post id: \(posts[idx].ID)")
                return posts[idx].ID
            }
            .bind(to: routes.detailPost)
            .disposed(by: disposeBag)
    }

    // MARK: - Methods
}
