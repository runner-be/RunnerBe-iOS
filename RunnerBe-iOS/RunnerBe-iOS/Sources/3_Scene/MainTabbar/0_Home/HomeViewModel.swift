//
//  HomeViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import RxSwift

final class HomeViewModel: BaseViewModel {
    private var locationService: LocationService
    private var mainPageAPIService: MainPageAPIService

    var posts: [Post] = []

    init(locationService: LocationService, mainPageAPIService: MainPageAPIService) {
        self.locationService = locationService
        self.mainPageAPIService = mainPageAPIService
        super.init()

        // TODO: 런칭땐 이 좌표값으로 Filter 작성
        // let currentLocation = locationService.currentPlace

        let initialFetchFilter = PostFilter(
            latitude: 36.123123123, longitude: 36.123123,
            wheterEnd: .closed,
            filter: .newest,
            distanceFilter: 10000,
            gender: .none,
            ageMin: 20,
            ageMax: 65,
            runningTag: .beforeWork
        )

//        mainPageAPIService.fetchPosts(with: initialFetchFilter)
//            .do(onNext: { [weak self] result in
//                if result == nil {
//                    self?.outputs.toast.onNext("서버 요청에 실패했습니다.")
//                }
//            })
//            .compactMap { $0 }
//            .subscribe(outputs.posts)
//            .disposed(by: disposeBag)

        inputs.filter
            .bind(to: routes.filter)
            .disposed(by: disposeBag)

        inputs.writingPost
            .bind(to: routes.writingPost)
            .disposed(by: disposeBag)
    }

    struct Input {
        var filter = PublishSubject<Void>()
        var writingPost = PublishSubject<Void>()
    }

    struct Output {
        var posts = ReplaySubject<[Post]>.create(bufferSize: 1)
        var toast = BehaviorSubject<String>(value: "")
    }

    struct Route {
        var filter = PublishSubject<Void>()
        var writingPost = PublishSubject<Void>()
    }

    var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
