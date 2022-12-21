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
    case memberWaitCertification(userId: Int, jwt: String, message: String)
    case nonMember(uuid: String, message: String)
    case stopped(message: String)
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

    static func MemberWaitCertification(json: JSON) throws -> LoginAPIResult {
        let result = json["result"]
        guard let userId = result["userId"].int,
              let jwt = result["jwt"].string,
              let message = result["message"].string
        else { throw JSONError.decoding }
        return LoginAPIResult.memberWaitCertification(userId: userId, jwt: jwt, message: message)
    }

    static func NonMember(json: JSON) throws -> LoginAPIResult {
        let result = json["result"]
        guard let uuid = result["uuid"].string,
              let message = result["message"].string
        else { throw JSONError.decoding }
        return LoginAPIResult.nonMember(uuid: uuid, message: message)
    }

    static func Stopped(json: JSON) throws -> LoginAPIResult {
        guard let message = json["message"].string
        else { throw JSONError.decoding }
        return LoginAPIResult.stopped(message: message)
    }
}
