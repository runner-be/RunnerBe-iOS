//
//  WritingDetailPostViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/21.
//

import Foundation
import RxSwift

final class WritingDetailPostViewModel: BaseViewModel {
    override init() {
        super.init()
    }

    struct Input {}
    struct Output {}
    struct Route {}

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
