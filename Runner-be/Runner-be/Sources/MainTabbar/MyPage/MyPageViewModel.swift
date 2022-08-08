//
//  MyPageViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import RxSwift

final class MyPageViewModel: BaseViewModel {
    enum PostType {
        case basic, attendable
    }

    var user: User?
    var posts = [PostType: [Post]]()

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
                case let .success(info, posting, joined):
                    let now = DateUtil.shared.now
                    self.user = info
                    let postings = posting.sorted(by: { $0.gatherDate > $1.gatherDate })
                    let joins = joined.sorted(by: { $0.gatherDate > $1.gatherDate })

                    self.posts[.basic] = postings
                    self.posts[.attendable] = joins

                    let posts = self.outputs.postType == .basic ? postings : joins
                    self.user = info
                    self.outputs.userInfo.onNext(UserConfig(from: info, owner: false))
                    self.outputs.posts.onNext(posts.map { MyPagePostConfig(post: $0, now: now) })
                case .error:
                    self.outputs.toast.onNext("불러오기에 실패했습니다.")
                }
            })
            .disposed(by: disposeBag)

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

        inputs.tapPost
            .compactMap { [weak self] idx in
                guard let self = self,
                      let posts = self.posts[self.outputs.postType],
                      idx >= 0, idx < posts.count
                else {
                    self?.outputs.toast.onNext("해당 포스트를 여는데 실패했습니다.")
                    return nil
                }
                print("post id: \(posts[idx].ID)")
                return posts[idx].ID
            }
            .bind(to: routes.detailPost)
            .disposed(by: disposeBag)

        inputs.bookMark
            .compactMap { [weak self] idx -> Post? in
                guard let self = self,
                      let posts = self.posts[self.outputs.postType],
                      idx >= 0, idx < posts.count
                else {
                    self?.outputs.toast.onNext("북마크를 실패했습니다.")
                    return nil
                }
                return posts[idx]
            }
            .flatMap { postAPIService.bookmark(postId: $0.ID, mark: !$0.marked) }
            .subscribe(onNext: { [weak self] result in
                guard let self = self,
                      let posts = self.posts[self.outputs.postType],
                      let idx = posts.firstIndex(where: { $0.ID == result.postId })
                else {
                    self?.outputs.toast.onNext("북마크를 실패했습니다.")
                    return
                }

                self.posts[self.outputs.postType]![idx].marked = result.mark
                self.outputs.marked.onNext((type: self.outputs.postType, idx: idx, marked: result.mark))
            })
            .disposed(by: disposeBag)

        inputs.attend
            .compactMap { [weak self] idx -> Post? in
                guard let self = self,
                      let posts = self.posts[self.outputs.postType],
                      idx >= 0, idx < posts.count
                else {
                    self?.outputs.toast.onNext("참석하기 요청중 오류가 발생했습니다.")
                    return nil
                }
                return posts[idx]
            }
            .flatMap { postAPIService.attendance(postId: $0.ID) }
            .subscribe(onNext: { [weak self] result in
                guard result.success,
                      let self = self,
                      let posts = self.posts[self.outputs.postType],
                      let idx = posts.firstIndex(where: { $0.ID == result.postId })
                else {
                    self?.outputs.toast.onNext("참석하기 요청중 오류가 발생했습니다.")
                    return
                }

                self.posts[self.outputs.postType]![idx].attendance = true
                self.outputs.attend.onNext((type: self.outputs.postType, idx: idx, state: PostAttendState.attend))
            })
            .disposed(by: disposeBag)

        inputs.settings
            .bind(to: routes.settings)
            .disposed(by: disposeBag)

        inputs.editInfo
            .compactMap { [weak self] _ -> User? in
                if let user = self?.user {
                    return user
                }
                self?.outputs.toast.onNext("내 정보를 가져오는데 실패했습니다.")
                return nil
            }
            .bind(to: routes.editInfo)
            .disposed(by: disposeBag)

        inputs.toMain
            .bind(to: routes.toMain)
            .disposed(by: disposeBag)

        inputs.writePost
            .bind(to: routes.writePost)
            .disposed(by: disposeBag)
    }

    struct Input {
        var typeChanged = PublishSubject<PostType>()
        var settings = PublishSubject<Void>()
        var editInfo = PublishSubject<Void>()
        var tapPost = PublishSubject<Int>()
        var bookMark = PublishSubject<Int>()
        var attend = PublishSubject<Int>()
        var toMain = PublishSubject<Void>()
        var writePost = PublishSubject<Void>()
    }

    struct Output {
        var postType: PostType = .basic
        var userInfo = ReplaySubject<UserConfig>.create(bufferSize: 1)
        var posts = ReplaySubject<[MyPagePostConfig]>.create(bufferSize: 1)
        var marked = PublishSubject<(type: PostType, idx: Int, marked: Bool)>()
        var attend = PublishSubject<(type: PostType, idx: Int, state: PostAttendState)>()
        var toast = BehaviorSubject<String>(value: "")
    }

    struct Route {
        var detailPost = PublishSubject<Int>()
        var needUpdates = PublishSubject<Void>()
        var editInfo = PublishSubject<User>()
        var settings = PublishSubject<Void>()
        var writePost = PublishSubject<Void>()
        var toMain = PublishSubject<Void>()
    }

    struct RouteInput {
        var needUpdate = PublishSubject<Bool>()
        var detailClosed = PublishSubject<Void>()
    }

    var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
