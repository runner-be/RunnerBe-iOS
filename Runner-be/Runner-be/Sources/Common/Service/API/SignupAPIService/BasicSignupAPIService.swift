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
            .map { try? JSON(data: $0.data) }
            .map { json -> (response: BasicResponse, json: JSON)? in
                guard let json = json
                else {
                    Log.d(tag: .network, "result: nil")
                    return nil
                }

                Log.d(tag: .network, "result: \n\(json)")
                return try? (response: BasicResponse(json: json), json: json)
            }
            .map {
                guard let result = $0
                else { return nil }
                return SignupAPIResult(json: result.json, code: result.response.code)
            }
    }
}
