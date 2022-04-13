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

    init(loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared) {
        self.loginKeyChainService = loginKeyChainService
        super.init()
        outputs.loginType = loginKeyChainService.loginType

        Observable.of(loginKeyChainService.loginType)
            .subscribe(onNext: { [weak self] loginType in
                switch loginType {
                case .nonMember:
                    self?.routes.onboardingCover.onNext(())
                case .waitCertification:
                    self?.routes.waitOnboardingCover.onNext(())
                case .member:
                    break
                }
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
                self?.outputs.loginType = loginKeyChainService.loginType
            })
            .disposed(by: disposeBag)

        routeInputs.needCover
            .subscribe(onNext: { [weak self] in
                guard let self = self else {
                    return
                }

                switch self.outputs.loginType {
                case .nonMember:
                    self.routes.onboardingCover.onNext(())
                case .waitCertification:
                    self.routes.waitOnboardingCover.onNext(())
                case .member:
                    break
                }
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
        var loginType: LoginType = .nonMember
        var home = PublishSubject<Void>()
    }

    struct Route {
        var home = PublishSubject<Void>()
        var bookmark = PublishSubject<Void>()
        var myPage = PublishSubject<Void>()
        var onboardingCover = ReplaySubject<Void>.create(bufferSize: 1)
        var waitOnboardingCover = ReplaySubject<Void>.create(bufferSize: 1)
    }

    struct RouteInput {
        var onboardingCoverClosed = PublishSubject<Void>()
        var toHome = PublishSubject<Void>()
        var needCover = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
