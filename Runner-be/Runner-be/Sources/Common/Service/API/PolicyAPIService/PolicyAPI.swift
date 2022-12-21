//
//  PolicyAPI.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/02.
//

import Foundation
import Moya

enum PolicyAPI {
    case policy(type: PolicyType)
}

// https://raw.githubusercontent.com/runner-be/runner-be.github.io/main/policy/policy_location.txt
extension PolicyAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://raw.githubusercontent.com/")!
    }

    var path: String {
        switch self {
        case let .policy(type):
            return "runner-be/runner-be.github.io/main/policy/\(type.fName).txt"
        }
    }

    var method: Moya.Method {
        switch self {
        case .policy:
            return Method.get
        }
    }

    var task: Task {
        switch self {
        case .policy:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        case .policy:
            return nil
        }
    }
}
