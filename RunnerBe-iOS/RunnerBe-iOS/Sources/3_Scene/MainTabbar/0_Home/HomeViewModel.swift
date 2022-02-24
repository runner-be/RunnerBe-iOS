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
    private var mainPageAPIService: MainPageAPIService

    var bookMarkSet = Set<Int>()
    var posts: [Post] = []
    var filter: PostFilter

    init(locationService: LocationService, mainPageAPIService: MainPageAPIService) {
        self.locationService = locationService
        self.mainPageAPIService = mainPageAPIService

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

//        mainPageAPIService.fetchPostsBookMarked()
//            .do(onNext: { [weak self] result in
//                if let result = result {
//                    self?.bookMarkSet = result.reduce(into: Set<Int>()) { $0.insert($1.id) }
//                }
//            })
//            .flatMap { _ in mainPageAPIService.fetchPosts(with: initialFilter) }
//            .do(onNext: { [weak self] result in
//                if result == nil {
//                    self?.outputs.toast.onNext("게시글 불러오기에 실패했습니다.")
//                }
//            })
//            .compactMap { $0 }
//            .map { [bookMarkSet] posts in
//                posts.reduce(into: [Post]()) {
//                    var post = $1
//                    post.bookMarked = bookMarkSet.contains($1.id)
//                    $0.append($1)
//                }
//            }
//            .subscribe(onNext: { [weak self] posts in
//                self?.posts = posts
//                self?.outputs.posts.onNext(posts)
//            })
//            .disposed(by: disposeBag)

        mainPageAPIService.fetchPosts(with: filter)
            .do(onNext: { [weak self] result in
                if result == nil {
                    self?.outputs.toast.onNext("서버 요청에 실패했습니다.")
                }
            })
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] posts in
                self?.posts = posts
                self?.outputs.posts.onNext(posts)
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
            .flatMap { filter in mainPageAPIService.fetchPosts(with: filter) }
            .do(onNext: { [weak self] result in
                if result == nil {
                    self?.outputs.toast.onNext("필터 적용에 실패했습니다.")
                    // TODO: tag 다시 이전 상태로 돌리기
                }
            })
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] posts in
                self?.posts = posts
                self?.outputs.posts.onNext(posts)
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
            .flatMap { mainPageAPIService.fetchPosts(with: $0) }
            .do(onNext: { [weak self] result in
                if result == nil {
                    self?.outputs.toast.onNext("필터 적용에 실패했습니다.")
                    // TODO: 마감포함 다시 원위치
                }
            })
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] posts in
                self?.posts = posts
                self?.outputs.posts.onNext(posts)
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
            .flatMap { mainPageAPIService.fetchPosts(with: $0) }
            .do(onNext: { [weak self] result in
                if result == nil {
                    self?.outputs.toast.onNext("필터 적용에 실패했습니다.")
                    // TODO: 필터 타입 원위치
                }
            })
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] posts in
                self?.posts = posts
                self?.outputs.posts.onNext(posts)
            })
            .disposed(by: disposeBag)

        inputs.tapPostBookMark
            .map { [weak self] idx in (idx: idx, post: self?.posts[idx]) }
            .filter { $0.post != nil }
            .flatMap { mainPageAPIService.bookmark(postId: $0.post!.id, mark: !$0.post!.bookMarked) }
            .subscribe(onNext: { [weak self] result in
                guard let self = self,
                      let index = self.posts.firstIndex(where: { $0.id == result.postId })
                else { return }

                self.posts[index].bookMarked = result.mark
                self.outputs.bookMarked.onNext((idx: index, marked: result.mark))
            })
            .disposed(by: disposeBag)

        routeInputs.needUpdate
            .filter { $0 }
            .compactMap { [weak self] _ in self?.filter }
            .flatMap { filter in
                mainPageAPIService.fetchPosts(with: filter)
            }
            .do(onNext: { [weak self] result in
                if result == nil {
                    self?.outputs.toast.onNext("새로고침에 실패했습니다.")
                }
            })
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] posts in
                self?.posts = posts
                self?.outputs.posts.onNext(posts)
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
                mainPageAPIService.fetchPosts(with: filter)
            }
            .do(onNext: { [weak self] result in
                if result == nil {
                    self?.outputs.toast.onNext("필터 적용에 실패했습니다.")
                    // TODO: 필터 아이콘 다시 이전 상태로 돌리기
                }
            })
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] posts in
                self?.posts = posts
                self?.outputs.posts.onNext(posts)
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
        var toast = BehaviorSubject<String>(value: "")
        var bookMarked = PublishSubject<(idx: Int, marked: Bool)>()
        var highLightFilter = PublishSubject<Bool>()
    }

    struct Route {
        var filter = PublishSubject<PostFilter>()
        var writingPost = PublishSubject<Void>()
    }

    struct RouteInput {
        var needUpdate = PublishSubject<Bool>()
        var filterChanged = PublishSubject<PostFilter>()
    }

    var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
