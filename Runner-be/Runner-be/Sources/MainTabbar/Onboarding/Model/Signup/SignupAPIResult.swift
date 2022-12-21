//
//  SignupAPIResult.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation
import SwiftyJSON

enum SignupAPIResult {
    case succeed(token: String, userId: Int)
    case error(Int)
}

extension SignupAPIResult {
    init(json: JSON, code: Int) {
        let resultJSON = json["result"]
        guard let token = resultJSON["token"].string,
              let userID = resultJSON["insertedUserId"].int
        else {
            self = .error(code)
            return
        }
        self = .succeed(token: token, userId: userID)
    }
}
