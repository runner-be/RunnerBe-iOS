//
//  ImageViewerViewModel.swift
//  Runner-be
//
//  Created by 김창규 on 7/11/24.
//

import Foundation
import RxSwift

final class ImageViewerViewModel: BaseViewModel {
    init(image: UIImage) {
        super.init()

        inputs.tapBackward
            .bind(to: routes.backward)
            .disposed(by: disposeBag)

        outputs.image.onNext(image)
    }

    struct Input {
        var tapBackward = PublishSubject<Void>()
    }

    struct Output {
        var image = BehaviorSubject<UIImage?>(value: nil)
    }

    struct Route {
        var backward = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
