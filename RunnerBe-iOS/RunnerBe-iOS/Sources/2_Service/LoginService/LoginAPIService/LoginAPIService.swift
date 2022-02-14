//
//  LoginAPIService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation
import RxSwift

protocol LoginAPIService {
    func login(with token: LoginToken) -> Observable<Bool>
    func login(with social: SocialLoginType, token: String) -> Observable<LoginAPIResult?>
}
