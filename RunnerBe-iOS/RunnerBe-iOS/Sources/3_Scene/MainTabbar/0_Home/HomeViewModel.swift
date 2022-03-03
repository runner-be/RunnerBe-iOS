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

    init(locationService: LocationService, postAPIService: PostAPIService) {
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
            distanceFilter: 500,
            gender: .none,
            ageMin: 20,
            ageMax: 65,
            runningTag: .beforeWork,
            jobFilter: .none,
            keywordSearch: ""
        )
        filter = initialFilter
        super.init()

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
            .compactMap { $0 }
            .map { posts in
                posts.reduce(into: [Post]()) { [weak self] partialResult, post in
                    guard let self = self else { return }
                    if self.filter.wheterEnd == .open, !post.open { return }
                    if self.bookMarkSet.contains(post.ID) { return }
                    partialResult.append(post)
                }
            }
            .subscribe(onNext: { [weak self] posts in
                self?.posts = posts
                self?.outputs.posts.onNext(posts)
                self?.outputs.refresh.onNext(())
            })
            .disposed(by: disposeBag)

        inputs.showDetailFilter
            .map { [weak self] in self?.filter ?? initialFilter }
            .bind(to: routes.filter)
            .disposed(by: disposeBag)

        inputs.writingPost
            .bind(to: routes.writingPost)
            .disposed(by: disposeBag)

        inputs.tagChanged
            .map { RunningTag(idx: $0) }
            .filter { $0 != .error }
            .map { [weak self] runningTag -> PostFilter? in
                guard var newFilter = self?.filter
                else { return nil }
                newFilter.runningTag = runningTag
                self?.filter = newFilter
                return newFilter
            }
            .compactMap { $0 }
            .flatMap { filter in postAPIService.fetchPosts(with: filter) }
            .do(onNext: { [weak self] result in
                if result == nil {
                    self?.outputs.toast.onNext("필터 적용에 실패했습니다.")
                    // TODO: tag 다시 이전 상태로 돌리기
                }
            })
            .compactMap { $0 }
            .map { posts in
                posts.reduce(into: [Post]()) { [weak self] partialResult, post in
//                    guard let self = self else { return }
//                    if self.filter.wheterEnd == .open, !post.open { return }
//                    var post = post
//                    post.marked = self.bookMarkSet.contains(post.ID)
//                    partialResult.append(post)
                    guard let self = self else { return }
                    if self.filter.wheterEnd == .open, !post.open { return }
                    if self.bookMarkSet.contains(post.ID) { return }
                    partialResult.append(post)
                }
            }
            .subscribe(onNext: { [weak self] posts in
                self?.posts = posts
                self?.outputs.posts.onNext(posts)
                self?.outputs.refresh.onNext(())
            })
            .disposed(by: disposeBag)

        inputs.deadLineChanged
            .map { $0 ? PostState.closed : PostState.open }
            .map { [weak self] state -> PostFilter? in
                guard var newFilter = self?.filter
                else { return nil }
                newFilter.wheterEnd = state
                self?.filter = newFilter
                return newFilter
            }
            .compactMap { $0 }
            .flatMap { postAPIService.fetchPosts(with: $0) }
            .do(onNext: { [weak self] result in
                if result == nil {
                    self?.outputs.toast.onNext("필터 적용에 실패했습니다.")
                    // TODO: 마감포함 다시 원위치
                }
            })
            .compactMap { $0 }
            .map { posts in
                posts.reduce(into: [Post]()) { [weak self] partialResult, post in
                    guard let self = self else { return }
                    if self.filter.wheterEnd == .open, !post.open { return }
                    if self.bookMarkSet.contains(post.ID) { return }
                    partialResult.append(post)
                }
            }
            .subscribe(onNext: { [weak self] posts in
                self?.posts = posts
                self?.outputs.posts.onNext(posts)
                self?.outputs.refresh.onNext(())
            })
            .disposed(by: disposeBag)

        inputs.filterTypeChanged
            .map { FilterType(idx: $0) }
            .filter { $0 != .error }
            .map { [weak self] filterType -> PostFilter? in
                guard var newFilter = self?.filter
                else { return nil }
                newFilter.filter = filterType
                self?.filter = newFilter
                return newFilter
            }
            .compactMap { $0 }
            .flatMap { postAPIService.fetchPosts(with: $0) }
            .do(onNext: { [weak self] result in
                if result == nil {
                    self?.outputs.toast.onNext("필터 적용에 실패했습니다.")
                    // TODO: 필터 타입 원위치
                }
            })
            .compactMap { $0 }
            .map { posts in
                posts.reduce(into: [Post]()) { [weak self] partialResult, post in
                    guard let self = self else { return }
                    if self.filter.wheterEnd == .open, !post.open { return }
                    if self.bookMarkSet.contains(post.ID) { return }
                    partialResult.append(post)
                }
            }
            .subscribe(onNext: { [weak self] posts in
                self?.posts = posts
                self?.outputs.posts.onNext(posts)
                self?.outputs.refresh.onNext(())
            })
            .disposed(by: disposeBag)

        inputs.tapPostBookMark
            .map { [weak self] idx in (idx: idx, post: self?.posts[idx]) }
            .filter { $0.post != nil }
            .flatMap { postAPIService.bookmark(postId: $0.post!.ID, mark: !$0.post!.marked) }
            .subscribe(onNext: { [weak self] result in
                guard let self = self,
                      let index = self.posts.firstIndex(where: { $0.ID == result.postId })
                else { return }
                self.posts.remove(at: index)
//                self.posts[index].marked = result.mark
//                if result.mark {
//                    self.bookMarkSet.insert(self.posts[index].ID)
//                } else {
//                    self.bookMarkSet.remove(self.posts[index].ID)
//                }
//                self.outputs.bookMarked.onNext((idx: index, marked: result.mark))
                self.outputs.posts.onNext(self.posts)
            })
            .disposed(by: disposeBag)

        inputs.tapPost
            .do(onNext: { [weak self] idx in
                guard let self = self,
                      idx >= 0, idx <= self.posts.count
                else {
                    self?.outputs.toast.onNext("해당 포스트를 찾을 수 없습니다.")
                    return
                }
            })
            .compactMap { [weak self] idx in self?.posts[idx].ID }
            .subscribe(routes.detailPost)
            .disposed(by: disposeBag)

        // MARK: - RouteInput

        routeInputs.needUpdate
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
            .compactMap { $0 }
            .map { posts in
                posts.reduce(into: [Post]()) { [weak self] partialResult, post in
                    guard let self = self else { return }
                    if self.filter.wheterEnd == .open, !post.open { return }
                    if self.bookMarkSet.contains(post.ID) { return }
                    partialResult.append(post)
                }
            }
            .subscribe(onNext: { [weak self] posts in
                self?.posts = posts
                self?.outputs.posts.onNext(posts)
                self?.outputs.refresh.onNext(())
            })
            .disposed(by: disposeBag)

        // TODO: 필터 아이콘 활성화 비활성화 어떻게 조절할지 생각
        routeInputs.filterChanged
            .do(onNext: { [weak self] inputFilter in
                print(inputFilter)
                print(initialFilter)
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
                newFilter.distanceFilter = inputFilter.distanceFilter / 1000.00
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
            .compactMap { $0 }
            .map { posts in
                posts.reduce(into: [Post]()) { [weak self] partialResult, post in
                    guard let self = self else { return }
                    if self.filter.wheterEnd == .open, !post.open { return }
                    if self.bookMarkSet.contains(post.ID) { return }
                    partialResult.append(post)
                }
            }
            .subscribe(onNext: { [weak self] posts in
                self?.posts = posts
                self?.outputs.posts.onNext(posts)
                self?.outputs.refresh.onNext(())
            })
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
