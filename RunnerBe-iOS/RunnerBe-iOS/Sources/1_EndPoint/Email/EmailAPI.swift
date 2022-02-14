//
//  EmailAPI.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/15.
//

import Foundation
import Moya

enum EmailAPI {
    case send(mail: Mails)
}

extension EmailAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.mailjet.com/v3.1")!
    }

    var path: String {
        return "send"
    }

    var method: Moya.Method {
        return .post
    }

    var task: Task {
        switch self {
        case let .send(mail):
            return .requestJSONEncodable(mail)
        }
    }

    var headers: [String: String]? {
        switch self {
        case .send:
            return [
                "Content-Type": "application/json",
                "Authorization": "Basic " +
                    "\(AppKeys.mailJetPublic):\(AppKeys.mailJetPrivate)".data(using: .nonLossyASCII)!.base64EncodedString(),
            ]
        }
    }
}
