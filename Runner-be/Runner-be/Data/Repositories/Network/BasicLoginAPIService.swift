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
            .mapResponse()
            .map { response in
                guard let response = response
                else {
                    return .nonMember
                }

                if !response.basic.isSuccess {
                    return .nonMember
                }

                switch response.basic.code {
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
            .mapResponse()
            .map {
                guard let response = $0
                else { return nil }

                switch response.basic.code {
                case let code where code == 1001: // 1001 = 회원 로그인 성공
                    return try? LoginAPIResult.Member(json: response.json)
                case let code where code == 1007:
                    return try? LoginAPIResult.MemberWaitCertification(json: response.json)
                case let code where code == 1002: // 1002 = 비회원 로그인 성공
                    return try? LoginAPIResult.NonMember(json: response.json)
                case let code where code == 2093:
                    return try? LoginAPIResult.Stopped(json: response.json)
                default:
                    return nil
                }
            }
    }
}
