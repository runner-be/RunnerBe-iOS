//
//  TakePhotoModalViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import Foundation
import RxSwift

final class TakePhotoModalViewModel: BaseViewModel {
    override init() {
        super.init()

        inputs.tapBackward
            .subscribe(routes.backward)
            .disposed(by: disposeBag)

        inputs.tapTakePhoto
            .subscribe(routes.takePhoto)
            .disposed(by: disposeBag)

        inputs.tapChoosePhoto
            .subscribe(routes.choosePhoto)
            .disposed(by: disposeBag)

        inputs.tapChooseDefault
            .subscribe(routes.chooseDefault)
            .disposed(by: disposeBag)
    }

    struct Input {
        var tapBackward = PublishSubject<Void>()
        var tapTakePhoto = PublishSubject<Void>()
        var tapChoosePhoto = PublishSubject<Void>()
        var tapChooseDefault = PublishSubject<Void>()
    }

    struct Output {}
    struct Route {
        var backward = PublishSubject<Void>()
        var takePhoto = PublishSubject<Void>()
        var choosePhoto = PublishSubject<Void>()
        var chooseDefault = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
