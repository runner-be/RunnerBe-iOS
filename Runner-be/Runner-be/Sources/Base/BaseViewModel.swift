//
//  BaseViewModel.swift
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
        Log.d(tag: .lifeCycle, "VM Initialized")
    }

    deinit {
        Log.d(tag: .lifeCycle, "VM Deinitailized")
    }

    var toast = PublishSubject<String?>()
    var toastActivity = PublishSubject<Bool>()
}
