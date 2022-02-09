//
//  PhotoCertificationViewModel.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import Foundation
import RxSwift

final class PhotoCertificationViewModel {
    init() {
        inputs.tapPhoto
            .subscribe(routes.photoModal)
            .disposed(by: disposeBag)

        inputs.tapBackward
            .subscribe(routes.backward)
            .disposed(by: disposeBag)

        inputs.tapCancel
            .subscribe(routes.cancel)
            .disposed(by: disposeBag)
    }

    struct Input {
        var tapCancel = PublishSubject<Void>()
        var tapBackward = PublishSubject<Void>()
        var tapPhoto = PublishSubject<Void>()
        var tapCertificate = PublishSubject<Void>()
    }

    struct Output {
        var enableCertificate = PublishSubject<Bool>()
    }

    struct Route {
        var photoModal = PublishSubject<Void>()
        var backward = PublishSubject<Void>()
        var cancel = PublishSubject<Void>()
    }

    struct RouteInput {
        var photoModal = PublishSubject<Data?>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
