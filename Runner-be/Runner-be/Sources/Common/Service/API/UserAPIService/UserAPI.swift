//
//  UserAPI.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/28.
//

import Foundation
import Moya

enum UserAPI {
    // https://docs.google.com/spreadsheets/d/1K3yR4ns25_ptuY9xEEvGObWE6k3PbYcziaaI26p9M7A/edit#gid=359925579
    case editNickName(toName: String, userId: Int, token: LoginToken)

    // https://docs.google.com/spreadsheets/d/1K3yR4ns25_ptuY9xEEvGObWE6k3PbYcziaaI26p9M7A/edit#gid=407517168
    case setJob(toJob: Job, userId: Int, token: LoginToken)

    // https://docs.google.com/spreadsheets/d/1K3yR4ns25_ptuY9xEEvGObWE6k3PbYcziaaI26p9M7A/edit#gid=420089353
    case setProfile(profileURL: String, userId: Int, token: LoginToken)

    case signout(userID: Int)

    case updateFCMToken(userID: Int, fcmToken: String)
    // https://docs.google.com/spreadsheets/d/1K3yR4ns25_ptuY9xEEvGObWE6k3PbYcziaaI26p9M7A/edit#gid=196917615
    case fetchAlarms(token: LoginToken)

    // https://docs.google.com/spreadsheets/d/1K3yR4ns25_ptuY9xEEvGObWE6k3PbYcziaaI26p9M7A/edit#gid=39753795
    case checkAlarms(token: LoginToken)
}

extension UserAPI: TargetType {
    var baseURL: URL {
        return BaseAPI.url
    }

    var path: String {
        switch self {
        case let .editNickName(_, userId, _):
            return "/users/\(userId)/name"
        case let .setJob(_, userId, _):
            return "/users/\(userId)/job"
        case let .setProfile(_, profileURL, _):
            return "/users/\(profileURL)/profileImage"
        case let .signout(userID: userID):
            return "/users/\(userID)"
        case let .updateFCMToken(userID, _):
            return "/users/\(userID)/deviceToken"
        case .fetchAlarms:
            return "/users/alarms"
        case .checkAlarms:
            return "/users/whether-new-alarms"
        }
    }

    var method: Moya.Method {
        switch self {
        case .editNickName:
            return Method.patch
        case .setJob:
            return Method.patch
        case .setProfile:
            return Method.patch
        case .signout:
            return Method.delete
        case .updateFCMToken:
            return Method.patch
        case .fetchAlarms:
            return Method.get
        case .checkAlarms:
            return Method.get
        }
    }

    var task: Task {
        switch self {
        case let .editNickName(toName, _, _):
            let parameters = ["nickName": toName]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case let .setJob(toJob, _, _):
            let parameters = ["job": toJob.code]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case let .setProfile(profileURL, _, _):
            let parameters = ["profileImageUrl": profileURL]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .signout:
            let parameters = ["secret_key": AppKeys.runnerbe]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case let .updateFCMToken(_, fcmToken):
            let parameters = ["deviceToken": fcmToken]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .fetchAlarms:
            return .requestPlain
        case .checkAlarms:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        case let .editNickName(_, _, token):
            return ["x-access-token": "\(token.jwt)"]
        case let .setJob(_, _, token):
            return ["x-access-token": "\(token.jwt)"]
        case let .setProfile(_, _, token):
            return ["x-access-token": "\(token.jwt)"]
        case .signout:
            return nil
        case .updateFCMToken:
            return nil
        case let .fetchAlarms(token):
            return ["x-access-token": "\(token.jwt)"]
        case let .checkAlarms(token):
            return ["x-access-token": "\(token.jwt)"]
        }
    }
}
