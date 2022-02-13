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

    init(provider: MoyaProvider<SignupAPI> = .init()) {
        self.provider = provider
    }

    func checkEmailOK(_ email: String) -> Observable<Bool> {
        provider.rx.request(.emailDup(email: email))
            .asObservable()
            .map { try? JSON(data: $0.data) }
            .map { json -> BasicResponse? in
                #if DEBUG
                    print("[SignupAPIService] checkEmailDuplicated(email: \(email)")
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
                return try? BasicResponse(json: json)
            }
            .map { $0?.isSuccess ?? false }
    }

    func signup(with signupForm: SignupForm) -> Observable<SignupResultData?> {
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
                return try? SignupResultData(json: result.json)
            }
    }
}
