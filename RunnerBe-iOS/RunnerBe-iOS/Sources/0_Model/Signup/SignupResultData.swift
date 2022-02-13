//
//  SignupResponse.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation
import SwiftyJSON

struct SignupResultData {
    let token: String

    init(json: JSON) throws {
        guard let token = json["result"].string
        else { throw JSONError.decoding }
        self.token = token
    }
}
