//
//  LoginResultData.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation
import SwiftyJSON

enum LoginResultData {
    case member(userId: Int, jwt: String, message: String)
    case nonMember(uuid: String, message: String)
}

extension LoginResultData {
    static func Member(json: JSON) throws -> LoginResultData {
        let result = json["result"]
        guard let userId = result["userId"].int,
              let jwt = result["jwt"].string,
              let message = result["message"].string
        else { throw JSONError.decoding }
        return LoginResultData.member(userId: userId, jwt: jwt, message: message)
    }

    static func NonMember(json: JSON) throws -> LoginResultData {
        let result = json["result"]
        guard let uuid = result["uuid"].string,
              let message = result["message"].string
        else { throw JSONError.decoding }
        return LoginResultData.nonMember(uuid: uuid, message: message)
    }
}
