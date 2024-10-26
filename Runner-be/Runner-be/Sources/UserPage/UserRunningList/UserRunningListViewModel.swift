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
        var posts = ReplaySubject<[UserPagePostConfig]>.create(bufferSize: 1)
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

    var posts = [UserPost]()

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
                        self.outputs.posts.onNext(userRunning.map { UserPagePostConfig(userPost: $0) })
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
                      idx >= 0,
                      idx < posts.count
                else {
                    self?.toast.onNext("해당 포스트를 여는데 실패했습니다.")
                    return nil
                }

                // 아직 시작안했을 때
                if Date().timeIntervalSince1970 < posts[idx].gatherDate.timeIntervalSince1970 {
                    self.toast.onNext("모임이 아직 시작되지 않았어요.")
                    return nil
                }
                print("sjeifosjf: \(posts[idx].postId)")
                return posts[idx].postId
            }
            .bind(to: routes.detailPost)
            .disposed(by: disposeBag)
    }

    // MARK: - Methods
}
