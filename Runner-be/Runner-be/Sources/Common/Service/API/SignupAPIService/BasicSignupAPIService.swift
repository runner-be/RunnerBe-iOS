//
//  BasicSignupService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation
import Moya
import RxSwift
import SwiftyJSON

final class BasicSignupAPIService: SignupAPIService {
    let provider: MoyaProvider<SignupAPI>

    init(provider: MoyaProvider<SignupAPI> = MoyaProvider<SignupAPI>(plugins: [VerbosePlugin(verbose: true)])) {
        self.provider = provider
    }

    func signup(with signupForm: SignupForm) -> Observable<SignupAPIResult?> {
        provider.rx.request(.signup(signupForm))
            .asObservable()
            .mapResponse()
            .map {
                guard let response = $0
                else { return nil }
                return SignupAPIResult(json: response.json, code: response.basic.code)
            }
    }
}
