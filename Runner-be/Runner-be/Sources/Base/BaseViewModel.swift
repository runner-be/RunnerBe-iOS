//
//  ViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import Foundation
import RxSwift

class BaseViewModel {
    init() {
        #if DEBUG
            print("[init:   ViewModel]  \(Self.self) ")
        #endif
    }

    deinit {
        #if DEBUG
            print("[deinit: ViewModel]  \(Self.self)")
        #endif
    }
}
