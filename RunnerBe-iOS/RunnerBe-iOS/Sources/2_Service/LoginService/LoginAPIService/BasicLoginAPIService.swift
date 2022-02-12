//
//  BasicLoginAPIService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation
import Moya
import RxSwift
import SwiftyJSON

class BasicLoginAPIService: LoginAPIService {
    let provider: MoyaProvider<LoginAPI>

    init(provider: MoyaProvider<LoginAPI> = .init()) {
        self.provider = provider
    }

    func login(with _: LoginToken) -> Observable<Bool> {
        // TODO: login with token
        return .just(false)
    }

    func login(with social: SocialLoginType, token: String) -> Observable<LoginResultData?> {
        provider.rx.request(.login(type: social, token: token))
            .asObservable()
            .map { try? JSON(data: $0.data) }
            .map { json -> (response: LoginResponse, json: JSON)? in
                #if DEBUG
                    print("[LoginAPIService] login(with: \(social), token: \(token))")
                #endif
                guard let json = json
                else {
                    #if DEBUG
                        print("result: nil")
                    #endif
                    return nil
                }
                #if DEBUG
                    print("result:\n\(json)")
                #endif
                return try? (response: LoginResponse(json: json), json: json)
            }
            .map {
                guard let result = $0
                else { return nil }
                switch result.response.code {
                case let code where code == 1001:
                    return try? LoginResultData.Member(json: result.json)
                case let code where code == 1002:
                    return try? LoginResultData.NonMember(json: result.json)
                default:
                    return nil
                }
            }
    }
}
