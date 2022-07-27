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
    private var posts: [Post] = []
    private var selectedPostID: Int?
    var filter: PostFilter

    init(
        postAPIService: PostAPIService = BasicPostAPIService(),
        locationService: LocationService = BasicLocationService.shared,
        loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared
    ) {
        let searchLocation = locationService.currentPlace

        let initialFilter = PostFilter(
            latitude: searchLocation.latitude, longitude: searchLocation.longitude,
            postState: .open,
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

        outputs.changeRegion.onNext((
            CLLocationCoordinate2D(latitude: filter.latitude, longitude: filter.longitude),
            Double(filter.distanceFilter * 1000)
        ))

        // MARK: Fetch Posts

        let postReady = ReplaySubject<[Post]?>.create(bufferSize: 1)
        postReady
            .compactMap { $0 }
            .map { [weak self] posts -> [Post] in
                if self?.filter.postState == .open {
                    return posts.filter { post in post.open }
                } else {
                    return posts
                }
            }
            .subscribe(onNext: { [weak self] posts in
                self?.posts = posts
                self?.outputs.posts.onNext(posts)
                self?.outputs.focusSelectedPost.onNext(nil)
                self?.outputs.refresh.onNext(())
                self?.outputs.showRefreshRegion.onNext(false)
            })
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

        inputs.tapShowClosedPost
            .skip(1)
            .map { [unowned self] () -> Bool in
                var newFilter = self.filter
                newFilter.postState = self.filter.postState.toggled
                self.filter = newFilter
                return self.filter.postState == .closed
            }
            .subscribe(onNext: { [weak self] showClosedPost in
                self?.routeInputs.needUpdate.onNext(true)
                self?.outputs.showClosedPost.onNext(showClosedPost)
            })
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
            .skip(1)
            .map { [unowned self] in self.filter }
            .bind(to: routes.filter)
            .disposed(by: disposeBag)

        inputs.writingPost
            // TODO: 시작시 이벤트가 바로 들어오는 현상이 있음 그래서 skip 1 해결방안 찾으면 수정할 것
            .skip(1)
            .subscribe(onNext: { [unowned self] in
                if loginKeyChainService.loginType != .member {
                    self.routes.nonMemberCover.onNext(())
                } else {
                    self.routes.writingPost.onNext(())
                }
            })
            .disposed(by: disposeBag)

        inputs.tapPostBookmark
            .do(onNext: { [unowned self] _ in
                if loginKeyChainService.loginType != .member {
                    self.routes.nonMemberCover.onNext(())
                }
            })
            .filter { _ in loginKeyChainService.loginType == .member }
            .compactMap { [unowned self] id -> (idx: Int, post: Post)? in
                if let idx = self.posts.firstIndex(where: { $0.ID == id }) {
                    return (idx: idx, post: self.posts[idx])
                } else {
                    return nil
                }
            }
            .flatMap { postAPIService.bookmark(postId: $0.post.ID, mark: !$0.post.marked) }
            .subscribe(onNext: { [weak self] result in
                guard let self = self,
                      let index = self.posts.firstIndex(where: { $0.ID == result.postId })
                else { return }
                self.posts[index].marked = result.mark
                self.outputs.bookMarked.onNext((id: result.postId, marked: result.mark))
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
            .filter { $0 }
            .compactMap { [weak self] _ in
                self?.filter
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
                    inputFilter.jobFilter == initialFilter.jobFilter

                self?.outputs.highLightFilter.onNext(!notChanged)
            })
            .map { [weak self] inputFilter -> PostFilter? in
                guard var newFilter = self?.filter
                else { return nil }
                newFilter.gender = inputFilter.gender
                newFilter.ageMax = inputFilter.ageMax
                newFilter.ageMin = inputFilter.ageMin
                newFilter.jobFilter = inputFilter.jobFilter
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
                self.outputs.bookMarked.onNext((id: result.id, marked: result.marked))
                self.outputs.posts.onNext(self.posts)
                self.outputs.focusSelectedPost.onNext(nil)
            })
            .disposed(by: disposeBag)

        locationService.locationEnableState
            .subscribe(onNext: { [weak self] _ in
                self?.routeInputs.needUpdate.onNext(true)
            })
            .disposed(by: disposeBag)

        // mapview
        inputs.regionChanged
            .subscribe(onNext: { [weak self] region in
                self?.filter.latitude = region.location.latitude
                self?.filter.longitude = region.location.longitude
                self?.filter.distanceFilter = Float(region.radius / 1000)
                self?.outputs.showRefreshRegion.onNext(true)
            })
            .disposed(by: disposeBag)

        inputs.moveRegion
            .subscribe(onNext: { [weak self] in
                self?.outputs.showRefreshRegion.onNext(false)
            })
            .disposed(by: disposeBag)

        inputs.needUpdate
            .bind(to: routeInputs.needUpdate)
            .disposed(by: disposeBag)

        inputs.toHomeLocation
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let currentPlace = locationService.currentPlace
                self.filter.latitude = currentPlace.latitude
                self.filter.longitude = currentPlace.longitude
                self.filter.distanceFilter = 3
                self.outputs.changeRegion.onNext((
                    locationService.currentPlace,
                    Double(self.filter.distanceFilter * 1000)
                ))
            })
            .disposed(by: disposeBag)

        inputs.tapPostPin
            .subscribe(onNext: { [weak self] id in
                let post = self?.posts.first(where: { $0.ID == id })
                self?.selectedPostID = id
                self?.outputs.focusSelectedPost.onNext(post)
            })
            .disposed(by: disposeBag)

        inputs.tapSelectedPost
            .compactMap { [weak self] _ in self?.posts.firstIndex(where: { $0.ID == self?.selectedPostID }) }
            .bind(to: inputs.tapPost)
            .disposed(by: disposeBag)

        // post list option
        inputs.tapPostListOrder
            .skip(1)
            .bind(to: routes.postListOrder)
            .disposed(by: disposeBag)

        routeInputs.postListOrderChanged
            .subscribe(onNext: { [unowned self] postListOrder in
                let currentCenterLocation = CLLocation(
                    latitude: self.filter.latitude,
                    longitude: self.filter.longitude
                )
                self.posts = self.posts.sorted(by: { pLeft, pRight in
                    switch postListOrder {
                    case .distance:
                        guard let leftCoord = pLeft.coord,
                              let rightCoord = pRight.coord
                        else { return true }

                        let pLeftLocation = CLLocation(
                            latitude: Double(leftCoord.lat),
                            longitude: Double(leftCoord.long)
                        )
                        let pRightLocation = CLLocation(
                            latitude: Double(rightCoord.lat),
                            longitude: Double(rightCoord.long)
                        )
                        return currentCenterLocation.distance(from: pLeftLocation) < currentCenterLocation.distance(from: pRightLocation)
                    case .latest:
                        return pLeft.postingTime < pRight.postingTime
                    }
                })
                self.outputs.posts.onNext(self.posts)
                self.outputs.postListOrderChanged.onNext(postListOrder)
            })
            .disposed(by: disposeBag)

        inputs.tapRunningTag
            .skip(1)
            .bind(to: routes.runningTag)
            .disposed(by: disposeBag)

        routeInputs.runningTagChanged
            .subscribe(onNext: { [unowned self] tag in
                self.inputs.tagChanged.onNext(tag.idx)
                self.outputs.runningTagChanged.onNext(tag)
            })
            .disposed(by: disposeBag)
    }

    struct Input {
        var showDetailFilter = PublishSubject<Void>()
        var writingPost = PublishSubject<Void>()
        var tapShowClosedPost = PublishSubject<Void>()
        var tagChanged = PublishSubject<Int>()
        var filterTypeChanged = PublishSubject<Int>()
        var tapPostBookmark = PublishSubject<Int>()
        var tapPostBookMarkWithId = PublishSubject<Int>()
        var tapPost = PublishSubject<Int>()
        var tapSelectedPost = PublishSubject<Void>()
        var regionChanged = PublishSubject<(location: CLLocationCoordinate2D, radius: CLLocationDistance)>()
        var moveRegion = PublishSubject<Void>()
        var needUpdate = PublishSubject<Bool>()
        var toHomeLocation = PublishSubject<Void>()
        var tapPostPin = PublishSubject<Int?>()
        var tapPostListOrder = PublishSubject<Void>()
        var tapRunningTag = PublishSubject<Void>()
    }

    struct Output {
        var posts = ReplaySubject<[Post]>.create(bufferSize: 1)
        var refresh = PublishSubject<Void>()
        var toast = PublishSubject<String>()
        var bookMarked = PublishSubject<(id: Int, marked: Bool)>()
        var highLightFilter = PublishSubject<Bool>()
        var showClosedPost = PublishSubject<Bool>()
        var showRefreshRegion = PublishSubject<Bool>()
        var changeRegion = ReplaySubject<(location: CLLocationCoordinate2D, distance: CLLocationDistance)>.create(bufferSize: 1)
        var focusSelectedPost = PublishSubject<Post?>()
        var postListOrderChanged = PublishSubject<PostListOrder>()
        var runningTagChanged = PublishSubject<RunningTag>()
    }

    struct Route {
        var filter = PublishSubject<PostFilter>()
        var writingPost = PublishSubject<Void>()
        var detailPost = PublishSubject<Int>()
        var nonMemberCover = PublishSubject<Void>()
        var postListOrder = PublishSubject<Void>()
        var runningTag = PublishSubject<Void>()
    }

    struct RouteInput {
        var needUpdate = PublishSubject<Bool>()
        var filterChanged = PublishSubject<PostFilter>()
        var detailClosed = PublishSubject<(id: Int, marked: Bool)>()
        var postListOrderChanged = PublishSubject<PostListOrder>()
        var runningTagChanged = PublishSubject<RunningTag>()
    }

    var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
