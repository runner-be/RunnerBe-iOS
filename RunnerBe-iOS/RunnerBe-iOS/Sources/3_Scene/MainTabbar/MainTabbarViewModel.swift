//
//  MainTabbarViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/26.
//
import Foundation
import RxSwift

final class MainTabViewModel: BaseViewModel {
    var loginKeyChainService: LoginKeyChainService

    init(loginKeyChainService: LoginKeyChainService) {
        self.loginKeyChainService = loginKeyChainService
        super.init()
        outputs.certificated = loginKeyChainService.certificated

        Observable.of(loginKeyChainService.certificated)
            .debug()
            .filter { !$0 }
            .map { _ in }
            .subscribe(onNext: { [weak self] in
                self?.routes.onboardingCover.onNext(())
            })
            .disposed(by: disposeBag)

        inputs.homeSelected
            .bind(to: routes.home)
            .disposed(by: disposeBag)

        inputs.bookMarkSelected
            .bind(to: routes.bookmark)
            .disposed(by: disposeBag)

        inputs.myPageSelected
            .bind(to: routes.myPage)
            .disposed(by: disposeBag)

        inputs.showOnboardingCover
            .bind(to: routes.onboardingCover)
            .disposed(by: disposeBag)

        routeInputs.toHome
            .bind(to: outputs.home)
            .disposed(by: disposeBag)

        routeInputs.onboardingCoverClosed
            .subscribe(onNext: { [weak self] in
                self?.outputs.certificated = loginKeyChainService.certificated
            })
            .disposed(by: disposeBag)
    }

    struct Input {
        var homeSelected = PublishSubject<Void>()
        var bookMarkSelected = PublishSubject<Void>()
        var myPageSelected = PublishSubject<Void>()
        var showOnboardingCover = PublishSubject<Void>()
    }

    struct Output {
        var certificated = false
        var home = PublishSubject<Void>()
    }

    struct Route {
        var home = PublishSubject<Void>()
        var bookmark = PublishSubject<Void>()
        var myPage = PublishSubject<Void>()
        var onboardingCover = ReplaySubject<Void>.create(bufferSize: 1)
    }

    struct RouteInput {
        var onboardingCoverClosed = PublishSubject<Void>()
        var toHome = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
