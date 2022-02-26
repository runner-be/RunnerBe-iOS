//
//  MainTabbarViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/26.
//
import Foundation
import RxSwift

final class MainTabViewModel: BaseViewModel {
    override init() {
        super.init()

        inputs.homeSelected
            .bind(to: routes.home)
            .disposed(by: disposeBag)

        inputs.bookMarkSelected
            .bind(to: routes.bookmark)
            .disposed(by: disposeBag)

        inputs.myPageSelected
            .bind(to: routes.myPage)
            .disposed(by: disposeBag)
    }

    struct Input {
        var homeSelected = PublishSubject<Void>()
        var bookMarkSelected = PublishSubject<Void>()
        var myPageSelected = PublishSubject<Void>()
    }

    struct Output {}

    struct Route {
        var home = PublishSubject<Void>()
        var bookmark = PublishSubject<Void>()
        var myPage = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
