//
//  EditInfoViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//
import Foundation
import RxSwift

final class EditInfoViewModel: BaseViewModel {
    var dirty: Bool = false

    override init() {
        super.init()

        inputs.backward
            .map { [weak self] in self?.dirty ?? true }
            .subscribe(routes.backward)
            .disposed(by: disposeBag)
    }

    struct Input {
        var backward = PublishSubject<Void>()
        var nickNameText = PublishSubject<String>()
        var nickNameApply = PublishSubject<String>()
        var changePhoto = PublishSubject<Void>()
        var jobSelected = PublishSubject<Int>()
    }

    struct Output {
        var duplicatedError = PublishSubject<Bool>()
        var ruleError = PublishSubject<Bool>()
    }

    struct Route {
        var backward = PublishSubject<Bool>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
