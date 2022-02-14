//
//  LoginAPI.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation
import Moya

enum LoginAPI {
    case socialLogin(type: SocialLoginType, token: String)
    case login(token: LoginToken)
}

extension LoginAPI: TargetType {
    var baseURL: URL {
        return BaseAPI.url
    }

    var path: String {
        switch self {
        case let .socialLogin(type, _):
            switch type {
            case .kakao:
                return "users/kakao-login"
            case .naver:
                return "users/naver-login"
            case .apple:
                fatalError("apple login not implemented")
            }
        case .login:
            return "users/auth"
        }
    }

    var method: Moya.Method {
        switch self {
        case .socialLogin:
            return .post
        case .login:
            return .get
        }
    }

    var task: Task {
        switch self {
        case let .socialLogin(_, token):
            return .requestParameters(parameters: ["accessToken": token], encoding: URLEncoding.default)
        case .login:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        case .socialLogin:
            return nil
        case let .login(token):
            return ["x-access-token": "\(token.jwt)"]
        }
    }
}
