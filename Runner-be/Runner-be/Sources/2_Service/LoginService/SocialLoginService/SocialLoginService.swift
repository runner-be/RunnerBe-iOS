//
//  LoginServiceable.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import Foundation
import RxSwift

protocol SocialLoginService {
    func login() -> Observable<SocialLoginResult>
}
