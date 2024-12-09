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
                    case let .success(_, posting, joined):
                        self.posts[.all] = joined.reversed()
                        self.posts[.myPost] = posting.reversed()

                        if let posts = self.posts[self.outputs.postType] {
                            self.outputs.newPosts.onNext(posts.map { PostConfig(from: $0) })
                        } else {
                            self.toast.onNext("불러오기에 실패했습니다.")
                        }
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
            .map { [weak self] postType in
                if postType != self?.outputs.postType {
                    self?.outputs.postType = postType
                    self?.outputs.newPosts.onNext([])
                    return true
                } else {
                    return false
                }
            }
            .bind(to: routeInputs.needUpdate)
            .disposed(by: disposeBag)

        inputs.tapPost
            .compactMap { [weak self] idx in
                guard let self = self,
                      let posts = self.posts[self.outputs.postType],
                      idx >= 0, idx < posts.count
                else {
                    self?.toast.onNext("해당 포스트를 여는데 실패했습니다.")
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
                    self?.toast.onNext("북마크를 실패했습니다.")
                    return nil
                }
                return posts[idx]
            }
            .flatMap { postAPIService.bookmark(postId: $0.ID, mark: !$0.marked) }
            .do(onNext: { [weak self] result in
                switch result {
                case .response:
                    return
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    }
                }
            })
            .compactMap { result -> (postId: Int, mark: Bool)? in
                switch result {
                case let .response(data):
                    return data
                case .error:
                    return nil
                }
            }
            .subscribe(onNext: { [weak self] result in
                guard let self = self,
                      let posts = self.posts[self.outputs.postType],
                      let _ = posts.firstIndex(where: { $0.ID == result.postId })
                else {
                    self?.toast.onNext("북마크를 실패했습니다.")
                    return
                }

                if let posts = self.posts[.all],
                   let idx = posts.firstIndex(where: { $0.ID == result.postId })
                {
                    self.posts[.all]![idx].marked = result.mark
                }

                if let posts = self.posts[.myPost],
                   let idx = posts.firstIndex(where: { $0.ID == result.postId })
                {
                    self.posts[.myPost]![idx].marked = result.mark
                }
                if let posts = self.posts[self.outputs.postType] {
                    self.outputs.newPosts.onNext(posts.map { PostConfig(from: $0) })
                } else {
                    self.toast.onNext("북마크를 실패했습니다.")
                }
            })
            .disposed(by: disposeBag)

        inputs.tapWriteLog
            .compactMap { [weak self] itemIndex in
                guard let self = self,
                      let selectedPost = self.posts[outputs.postType]?[itemIndex]
                else {
                    return nil
                }

                return LogForm(
                    runningDate: selectedPost.gatherDate,
                    logId: selectedPost.ID,
                    gatheringId: selectedPost.gatheringId,
                    stampCode: nil,
                    contents: nil,
                    imageUrl: nil,
                    weatherDegree: nil,
                    weatherIcon: nil,
                    isOpened: 1
                )
            }
            .bind(to: routes.writeLog)
            .disposed(by: disposeBag)

        inputs.tapConfirmLog
            .compactMap { [weak self] itemIndex in
                guard let self = self,
                      let selectedPost = self.posts[outputs.postType]?[itemIndex]
                else {
                    return nil
                }

                return selectedPost.logId
            }
            .bind(to: routes.confirmLog)
            .disposed(by: disposeBag)

        inputs.tapManageAttendance
            .compactMap { [weak self] index in
                guard let self = self else { return nil }
                return posts[outputs.postType]?[index].ID
            }
            .bind(to: routes.manageAttendance)
            .disposed(by: disposeBag)

        inputs.tapConfirmAttendance
            .compactMap { [weak self] index in
                guard let self = self else { return nil }
                return posts[outputs.postType]?[index].ID
            }
            .bind(to: routes.confirmAttendance)
            .disposed(by: disposeBag)
    }

    // MARK: - Methods

    struct Input {
        var typeChanged = PublishSubject<PostType>()
        var bookMark = PublishSubject<Int>()
        var tapWriteLog = PublishSubject<Int>()
        var tapConfirmLog = PublishSubject<Int>()
        var tapManageAttendance = PublishSubject<Int>()
        var tapConfirmAttendance = PublishSubject<Int>()
        var tapPost = PublishSubject<Int>()
    }

    struct Output {
        var postType: PostType = .all
        var posts = ReplaySubject<[MyPagePostConfig]>.create(bufferSize: 1)
        var newPosts = ReplaySubject<[PostConfig]>.create(bufferSize: 1)
    }

    struct Route {
        var backward = PublishSubject<Void>()
        var writeLog = PublishSubject<LogForm>()
        var confirmLog = PublishSubject<Int>()
        var manageAttendance = PublishSubject<Int>()
        var confirmAttendance = PublishSubject<Int>()
        var detailPost = PublishSubject<Int>()
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
