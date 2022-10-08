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

    init(provider: MoyaProvider<LoginAPI> = MoyaProvider<LoginAPI>(plugins: [VerbosePlugin(verbose: true)])) {
        self.provider = provider
    }

    func login(with token: LoginToken) -> Observable<LoginWithTokenResult> {
        provider.rx.request(.login(token: token))
            .asObservable()
            .map { try? JSON(data: $0.data) }
            .map { json in

                guard let json = json,
                      let response = try? BasicResponse(json: json)
                else {
                    return .nonMember
                }

                if !response.isSuccess {
                    return .nonMember
                }

                switch response.code {
                case let code where code == 1001: // 인증 된 회원
                    return .member
                case let code where code == 1007: // 인증 대기
                    return .waitCertification
                case let code where code == 2093:
                    return .stopped
                default:
                    return .nonMember
                }
            }
    }

    func login(with social: SocialLoginType, token: String) -> Observable<LoginAPIResult?> {
        provider.rx.request(.socialLogin(type: social, token: token))
            .asObservable()
            .map { try? JSON(data: $0.data) }
            .map { json -> (response: BasicResponse, json: JSON)? in
                guard let json = json
                else {
                    return nil
                }

                return try? (response: BasicResponse(json: json), json: json)
            }
            .map {
                guard let result = $0
                else { return nil }

                switch result.response.code {
                case let code where code == 1001: // 1001 = 회원 로그인 성공
                    return try? LoginAPIResult.Member(json: result.json)
                case let code where code == 1007:
                    return try? LoginAPIResult.MemberWaitCertification(json: result.json)
                case let code where code == 1002: // 1002 = 비회원 로그인 성공
                    return try? LoginAPIResult.NonMember(json: result.json)
                case let code where code == 2093:
                    return try? LoginAPIResult.Stopped(json: result.json)
                default:
                    return nil
                }
            }
    }
}
