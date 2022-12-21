//
//  SignupService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation
import RxSwift

enum SignupResult {
    case success
    case fail
}

protocol SignupService {
    func signup() -> Observable<SignupResult>
}
