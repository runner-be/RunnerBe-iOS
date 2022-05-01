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
                #if DEBUG
                    print("[SignupAPIService] signup(with: \(signupForm))")
                #endif
                guard let json = json
                else {
                    #if DEBUG
                        print("result: nil")
                    #endif
                    return nil
                }
                #if DEBUG
                    print("result: \n\(json)")
                #endif
                return try? (response: BasicResponse(json: json), json: json)
            }
            .map {
                guard let result = $0
                else { return nil }
                return SignupAPIResult(json: result.json, code: result.response.code)
            }
    }
}
