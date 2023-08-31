//
//  MainTabbarViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/26.
//
import Foundation
import RxSwift

final class MainTabViewModel: BaseViewModel {
    private let loginUseCase = LoginUseCase()

    override init() {
        super.init()

        requestDataToUseCase()
        uiBusinessLogic()
    }

    private func changeSceneIfMember(to index: Int) {
        if outputs.loginType == .member {
            outputs.selectScene.onNext(index)
            switch index {
            case 0:
                routes.home.onNext(())
            case 1:
                routes.bookmark.onNext(())
            case 2:
                routes.message.onNext(())
            case 3:
                routes.myPage.onNext(())
            default:
                break
            }
        } else {
            routes.onboardingCover.onNext(())
        }
    }

    struct Input { // View에서 ViewModel로 전달되는 이벤트가 있을때의 구조체
        var homeSelected = PublishSubject<Void>()
        var bookMarkSelected = PublishSubject<Void>()
        var messageSelected = PublishSubject<Void>()
        var myPageSelected = PublishSubject<Void>()
    }

    struct Output { // ViewModel에서 View로 전달되는 이벤트가 있을때의 구조체
        var loginType: LoginType = .nonMember
        var selectScene = PublishSubject<Int>()
    }

    struct Route { // 화면 전환 이벤트를 coordinator에 전달하는 구조체
        var home = PublishSubject<Void>()
        var bookmark = PublishSubject<Void>()
        var message = PublishSubject<Void>()
        var myPage = PublishSubject<Void>()
        var onboardingCover = ReplaySubject<Void>.create(bufferSize: 1)
    }

    struct RouteInput { // 자식 화면이 해제될때 (ex. 뒤로가기) 전달해야할 정보가 있을 경우, 해당 이벤트가 정의되어있는 구조체
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

extension MainTabViewModel {
    func requestDataToUseCase() {
        outputs.loginType = loginUseCase.loginType

        routeInputs.onboardingCoverClosed
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.outputs.loginType = self.loginUseCase.loginType
            })
            .disposed(by: disposeBag)
    }

    func uiBusinessLogic() {
        Observable.of(loginUseCase.loginType)
            .subscribe(onNext: { [weak self] loginType in
                switch loginType {
                case .nonMember:
                    self?.routes.onboardingCover.onNext(())
                case .waitCertification:
                    self?.routes.onboardingCover.onNext(())
                case .member:
                    break
                case .stopped:
                    break
                }
            })
            .disposed(by: disposeBag)

        inputs.homeSelected
            .subscribe(onNext: { [weak self] in
                self?.changeSceneIfMember(to: 0)
            })
            .disposed(by: disposeBag)

        inputs.bookMarkSelected
            .subscribe(onNext: { [weak self] in
                self?.changeSceneIfMember(to: 1)
            })
            .disposed(by: disposeBag)

        inputs.messageSelected
            .subscribe(onNext: { [weak self] in
                self?.changeSceneIfMember(to: 2)
            })
            .disposed(by: disposeBag)

        inputs.myPageSelected
            .subscribe(onNext: { [weak self] in
                self?.changeSceneIfMember(to: 3)
            })
            .disposed(by: disposeBag)

        routeInputs.toHome
            .map { 0 }
            .bind(to: outputs.selectScene)
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
                    self.routes.onboardingCover.onNext(())
                case .member:
                    break
                case .stopped:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}
