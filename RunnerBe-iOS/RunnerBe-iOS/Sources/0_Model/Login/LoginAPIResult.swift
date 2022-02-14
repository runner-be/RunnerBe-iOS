//
//  LoginAPIResult.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation
import SwiftyJSON

enum LoginAPIResult {
    case member(userId: Int, jwt: String, message: String)
    case memberNotCertificated(userId: Int, jwt: String, message: String)
    case nonMember(uuid: String, message: String)
}

extension LoginAPIResult {
    static func Member(json: JSON) throws -> LoginAPIResult {
        let result = json["result"]
        guard let userId = result["userId"].int,
              let jwt = result["jwt"].string,
              let message = result["message"].string
        else { throw JSONError.decoding }
        return LoginAPIResult.member(userId: userId, jwt: jwt, message: message)
    }

    static func MemberNonCertificated(json: JSON) throws -> LoginAPIResult {
        let result = json["result"]
        guard let userId = result["userId"].int,
              let jwt = result["jwt"].string,
              let message = result["message"].string
        else { throw JSONError.decoding }
        return LoginAPIResult.memberNotCertificated(userId: userId, jwt: jwt, message: message)
    }

    static func NonMember(json: JSON) throws -> LoginAPIResult {
        let result = json["result"]
        guard let uuid = result["uuid"].string,
              let message = result["message"].string
        else { throw JSONError.decoding }
        return LoginAPIResult.nonMember(uuid: uuid, message: message)
    }
}
