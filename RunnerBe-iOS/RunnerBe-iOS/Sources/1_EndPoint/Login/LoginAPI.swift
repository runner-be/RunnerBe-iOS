//
//  LoginAPI.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation
import Moya

enum LoginAPI {
    case login(type: SocialLoginType, token: String)
}

extension LoginAPI: TargetType {
    var baseURL: URL {
        return BaseAPI.url
    }

    var path: String {
        switch self {
        case let .login(type, _):
            switch type {
            case .kakao:
                return "users/kakao-login"
            case .naver:
                return "users/naver-login"
            case .apple:
                fatalError("apple login not implemented")
            }
        }
    }

    var method: Moya.Method {
        return .post
    }

    var task: Task {
        switch self {
        case let .login(_, token):
            return .requestParameters(parameters: ["accessToken": token], encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
