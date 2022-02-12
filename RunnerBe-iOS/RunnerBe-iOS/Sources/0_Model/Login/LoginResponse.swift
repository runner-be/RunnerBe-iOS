//
//  LoginResponse.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation
import SwiftyJSON

struct LoginResponse {
    let isSuccess: Bool
    let code: Int
    let message: String

    init(json: JSON) throws {
        guard let success = json["isSuccess"].bool,
              let code = json["code"].int,
              let message = json["message"].string
        else { throw JSONError.error("Json Decoding Error") }
        isSuccess = success
        self.code = code
        self.message = message
    }
}
