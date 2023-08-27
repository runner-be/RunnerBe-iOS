//
//  SelectGenderViewModel.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import Foundation
import RxSwift

final class SelectGenderViewModel: BaseViewModel {
    private let userUseCase = UserUseCase()

    // MARK: Lifecycle

    override init() {
        super.init()

        uiBusinessLogic()
        requestDataToRepo()
    }

    // MARK: Internal

    struct Input {
        var tapNext = PublishSubject<Void>()
        var tapCancel = PublishSubject<Void>()
        var tapBackward = PublishSubject<Void>()
        var tapGroup = PublishSubject<[Int]>()
    }

    struct Output {
        var enableNext = PublishSubject<Bool>()
    }

    struct Route {
        var nextProcess = PublishSubject<Void>()
        var backward = PublishSubject<Void>()
        var cancel = PublishSubject<Void>()
    }

    var inputs = Input()
    var outputs = Output()
    var routes = Route()

    // MARK: Private

    private var disposeBag = DisposeBag()
}

// MARK: - Repository와 소통

extension SelectGenderViewModel {
    func requestDataToRepo() {
        inputs.tapGroup
            .map { selected -> Gender in
                if let idx = selected.first,
                   idx < 2, idx >= 0
                {
                    return idx == 0 ? .female : .male
                }
                return .none
            }
            .do(onNext: { [weak self] gender in
                self?.userUseCase.setGender(gender: gender)
            })
            .map { $0 != .none }
            .bind(to: outputs.enableNext)
            .disposed(by: disposeBag)
    }
}

// MARK: - UI 관련 비즈니스 로직

extension SelectGenderViewModel {
    func uiBusinessLogic() {
        inputs.tapCancel
            .subscribe(routes.cancel)
            .disposed(by: disposeBag)

        inputs.tapBackward
            .subscribe(routes.backward)
            .disposed(by: disposeBag)

        inputs.tapNext
            .subscribe(routes.nextProcess)
            .disposed(by: disposeBag)
    }
}
