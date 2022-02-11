//
//  PhotoCertificationViewModel.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import Foundation
import RxSwift

enum ImagePickerType {
    case library
    case camera
}

final class PhotoCertificationViewModel: BaseViewModel {
    override init() {
        super.init()

        inputs.tapPhoto
            .subscribe(routes.photoModal)
            .disposed(by: disposeBag)

        inputs.tapBackward
            .subscribe(routes.backward)
            .disposed(by: disposeBag)

        inputs.tapCancel
            .subscribe(routes.cancel)
            .disposed(by: disposeBag)

        inputs.tapDeletePhoto
            .subscribe(onNext: { [weak self] in
                self?.outputs.photo.onNext(nil)
                self?.outputs.enableCertificate.onNext(false)
            })
            .disposed(by: disposeBag)

        routeInputs.photoModal
            .compactMap { $0 }
            .subscribe(routes.showPicker)
            .disposed(by: disposeBag)

        routeInputs.photoModal
            .map { $0 != nil }
            .subscribe(outputs.enableCertificate)
            .disposed(by: disposeBag)
    }

    struct Input {
        var tapCancel = PublishSubject<Void>()
        var tapBackward = PublishSubject<Void>()
        var tapPhoto = PublishSubject<Void>()
        var tapDeletePhoto = PublishSubject<Void>()
        var tapCertificate = PublishSubject<Void>()
    }

    struct Output {
        var photo = BehaviorSubject<Data?>(value: nil)
        var enableCertificate = PublishSubject<Bool>()
    }

    struct Route {
        var photoModal = PublishSubject<Void>()
        var showPicker = PublishSubject<ImagePickerType>()
        var backward = PublishSubject<Void>()
        var cancel = PublishSubject<Void>()
    }

    struct RouteInput {
        var photoModal = PublishSubject<ImagePickerType?>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
