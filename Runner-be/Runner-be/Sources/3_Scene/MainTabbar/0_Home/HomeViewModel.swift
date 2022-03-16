//
//  HomeViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import CoreLocation
import Foundation
import RxSwift

final class HomeViewModel: BaseViewModel {
    private var locationService: LocationService
    private var postAPIService: PostAPIService

    var bookMarkSet = Set<Int>()
    var posts: [Post] = []
    var filter: PostFilter

    init(locationService: LocationService, postAPIService: PostAPIService, loginKeyChainService: LoginKeyChainService) {
        self.locationService = locationService
        self.postAPIService = postAPIService

        // TODO: 런칭땐 이 좌표값으로 Filter 작성
        let searchLocation: CLLocationCoordinate2D
        if let currentLocation = locationService.currentPlace {
            searchLocation = currentLocation
        } else {
            searchLocation = CLLocationCoordinate2D(latitude: 36.12312312, longitude: 36.12312312)
        }

        let initialFilter = PostFilter(
            latitude: searchLocation.latitude, longitude: searchLocation.longitude,
            wheterEnd: .open,
            filter: .newest,
            distanceFilter: 3,
            gender: .none,
            ageMin: 20,
            ageMax: 65,
            runningTag: .beforeWork,
            jobFilter: .none,
            keywordSearch: ""
        )
        filter = initialFilter
        super.init()

        // MARK: Fetch Posts

        let postReady = ReplaySubject<[Post]?>.create(bufferSize: 1)
        postReady
            .compactMap { $0 }
            .map { posts in
                posts.reduce(into: [Post]()) { [weak self] partialResult, post in
                    guard let self = self else { return }
                    if self.filter.wheterEnd == .open, !post.open { return }
                    var post = post
                    post.marked = self.bookMarkSet.contains(post.ID)
                    partialResult.append(post)
                }
            }
            .subscribe(onNext: { [weak self] posts in
                self?.posts = posts
                self?.outputs.posts.onNext(posts)
                self?.outputs.refresh.onNext(())
            })
            .disposed(by: disposeBag)

        postAPIService.fetchPostsBookMarked()
            .do(onNext: { [weak self] result in
                if let result = result {
                    self?.bookMarkSet = result.reduce(into: Set<Int>()) { $0.insert($1.ID) }
                }
            })
            .flatMap { _ in postAPIService.fetchPosts(with: initialFilter) }
            .do(onNext: { [weak self] result in
                if result == nil {
                    self?.outputs.toast.onNext("게시글 불러오기에 실패했습니다.")
                }
            })
            .subscribe(onNext: { postReady.onNext($0) })
            .disposed(by: disposeBag)

        inputs.tagChanged
            .map { RunningTag(idx: $0) }
            .filter { $0 != .error }
            .map { [unowned self] runningTag -> PostFilter in
                var newFilter = self.filter
                newFilter.runningTag = runningTag
                self.filter = newFilter
                return newFilter
            }
            .flatMap { postAPIService.fetchPosts(with: $0) }
            .do(onNext: { [weak self] result in
                if result == nil {
                    self?.outputs.toast.onNext("필터 적용에 실패했습니다.")
                }
            })
            .subscribe(onNext: { postReady.onNext($0) })
            .disposed(by: disposeBag)

        inputs.deadLineChanged
            .map { $0 ? PostState.closed : PostState.open }
            .map { [unowned self] state -> PostFilter in
                var newFilter = self.filter
                newFilter.wheterEnd = state
                self.filter = newFilter
                return newFilter
            }
            .flatMap { postAPIService.fetchPosts(with: $0) }
            .do(onNext: { [weak self] result in
                if result == nil {
                    self?.outputs.toast.onNext("필터 적용에 실패했습니다.")
                    // TODO: 마감포함 다시 원위치
                }
            })
            .subscribe(onNext: { postReady.onNext($0) })
            .disposed(by: disposeBag)

        inputs.filterTypeChanged
            .map { FilterType(idx: $0) }
            .filter { $0 != .error }
            .map { [unowned self] filterType -> PostFilter in
                var newFilter = self.filter
                newFilter.filter = filterType
                self.filter = newFilter
                return newFilter
            }
            .flatMap { postAPIService.fetchPosts(with: $0) }
            .do(onNext: { [weak self] result in
                if result == nil {
                    self?.outputs.toast.onNext("필터 적용에 실패했습니다.")
                    // TODO: 필터 타입 원위치
                }
            })
            .subscribe(onNext: { postReady.onNext($0) })
            .disposed(by: disposeBag)

        // MARK: View Inputs

        inputs.showDetailFilter
            .map { [unowned self] in self.filter }
            .bind(to: routes.filter)
            .disposed(by: disposeBag)

        inputs.writingPost
            .subscribe(onNext: { [unowned self] in
                if loginKeyChainService.loginType != .member {
                    self.routes.nonMemberCover.onNext(())
                } else {
                    self.routes.writingPost.onNext(())
                }
            })
            .disposed(by: disposeBag)

        inputs.tapPostBookMark
            .do(onNext: { [unowned self] _ in
                if loginKeyChainService.loginType != .member {
                    self.routes.nonMemberCover.onNext(())
                }
            })
            .filter { _ in loginKeyChainService.loginType == .member }
            .map { [unowned self] idx in (idx: idx, post: self.posts[idx]) }
            .flatMap { postAPIService.bookmark(postId: $0.post.ID, mark: !$0.post.marked) }
            .subscribe(onNext: { [weak self] result in
                guard let self = self,
                      let index = self.posts.firstIndex(where: { $0.ID == result.postId })
                else { return }
                self.posts[index].marked = result.mark
                if result.mark {
                    self.bookMarkSet.insert(self.posts[index].ID)
                } else {
                    self.bookMarkSet.remove(self.posts[index].ID)
                }
                self.outputs.bookMarked.onNext((idx: index, marked: result.mark))
                self.outputs.posts.onNext(self.posts)
            })
            .disposed(by: disposeBag)

        inputs.tapPost
            .do(onNext: { [unowned self] _ in
                if loginKeyChainService.loginType != .member {
                    self.routes.nonMemberCover.onNext(())
                }
            })
            .filter { _ in loginKeyChainService.loginType == .member }
            .do(onNext: { [unowned self] idx in
                guard idx >= 0, idx <= self.posts.count
                else {
                    self.outputs.toast.onNext("해당 포스트를 찾을 수 없습니다.")
                    return
                }
            })
            .compactMap { [unowned self] idx in self.posts[idx].ID }
            .subscribe(routes.detailPost)
            .disposed(by: disposeBag)

        // MARK: - RouteInput

        routeInputs.needUpdate
            .do(onNext: { [weak self] _ in
                self?.bookMarkSet.removeAll()
            })
            .filter { $0 }
            .flatMap { _ in postAPIService.fetchPostsBookMarked() }
            .do(onNext: { [weak self] result in
                if let result = result {
                    self?.bookMarkSet = result.reduce(into: Set<Int>()) { $0.insert($1.ID) }
                }
            })
            .compactMap { [weak self] _ in
                guard let self = self,
                      let coord = locationService.currentPlace
                else { return nil }
                self.filter.latitude = coord.latitude
                self.filter.longitude = coord.longitude
                return self.filter
            }
            .flatMap { filter in
                postAPIService.fetchPosts(with: filter)
            }
            .do(onNext: { [weak self] result in
                if result == nil {
                    self?.outputs.toast.onNext("새로고침에 실패했습니다.")
                }
            })
            .subscribe(onNext: { postReady.onNext($0) })
            .disposed(by: disposeBag)

        routeInputs.filterChanged
            .do(onNext: { [weak self] inputFilter in
                let notChanged = inputFilter.ageMin == initialFilter.ageMin &&
                    inputFilter.ageMax == initialFilter.ageMax &&
                    inputFilter.gender == initialFilter.gender &&
                    inputFilter.jobFilter == initialFilter.jobFilter &&
                    inputFilter.distanceFilter == initialFilter.distanceFilter

                self?.outputs.highLightFilter.onNext(!notChanged)
            })
            .map { [weak self] inputFilter -> PostFilter? in
                guard var newFilter = self?.filter
                else { return nil }
                newFilter.gender = inputFilter.gender
                newFilter.ageMax = inputFilter.ageMax
                newFilter.ageMin = inputFilter.ageMin
                newFilter.jobFilter = inputFilter.jobFilter
                newFilter.latitude = inputFilter.latitude
                newFilter.longitude = inputFilter.longitude
                newFilter.distanceFilter = inputFilter.distanceFilter
                self?.filter = newFilter
                return newFilter
            }
            .compactMap { $0 }
            .flatMap { filter in
                postAPIService.fetchPosts(with: filter)
            }
            .do(onNext: { [weak self] result in
                if result == nil {
                    self?.outputs.toast.onNext("필터 적용에 실패했습니다.")
                    // TODO: 필터 아이콘 다시 이전 상태로 돌리기
                }
            })
            .subscribe(onNext: { postReady.onNext($0) })
            .disposed(by: disposeBag)

        routeInputs.detailClosed
            .subscribe(onNext: { [weak self] result in
                guard let self = self,
                      let index = self.posts.firstIndex(where: { $0.ID == result.id })
                else { return }

                self.posts[index].marked = result.marked
                if result.marked {
                    self.bookMarkSet.insert(self.posts[index].ID)
                } else {
                    self.bookMarkSet.remove(self.posts[index].ID)
                }
                self.outputs.bookMarked.onNext((idx: index, marked: result.marked))
                self.outputs.posts.onNext(self.posts)
            })
            .disposed(by: disposeBag)
    }

    struct Input {
        var showDetailFilter = PublishSubject<Void>()
        var writingPost = PublishSubject<Void>()
        var deadLineChanged = PublishSubject<Bool>()
        var tagChanged = PublishSubject<Int>()
        var filterTypeChanged = PublishSubject<Int>()
        var tapPostBookMark = PublishSubject<Int>()
        var tapPost = PublishSubject<Int>()
    }

    struct Output {
        var posts = ReplaySubject<[Post]>.create(bufferSize: 1)
        var refresh = PublishSubject<Void>()
        var toast = BehaviorSubject<String>(value: "")
        var bookMarked = PublishSubject<(idx: Int, marked: Bool)>()
        var highLightFilter = PublishSubject<Bool>()
    }

    struct Route {
        var filter = PublishSubject<PostFilter>()
        var writingPost = PublishSubject<Void>()
        var detailPost = PublishSubject<Int>()
        var nonMemberCover = PublishSubject<Void>()
    }

    struct RouteInput {
        var needUpdate = PublishSubject<Bool>()
        var filterChanged = PublishSubject<PostFilter>()
        var detailClosed = PublishSubject<(id: Int, marked: Bool)>()
    }

    var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
