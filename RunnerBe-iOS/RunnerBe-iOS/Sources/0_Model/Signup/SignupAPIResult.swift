//
//  SignupAPIResult.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation
import SwiftyJSON

enum SignupAPIResult {
    case succeed(token: String)
    case error(Int)
}

extension SignupAPIResult {
    init(json: JSON, code: Int) {
        guard let token = json["result"].string
        else {
            self = .error(code)
            return
        }
        self = .succeed(token: token)
    }
}
