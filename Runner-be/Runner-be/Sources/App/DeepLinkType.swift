//
//  DeepLinkType.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/15.
//

import Foundation

enum DeepLinkType {}

extension DeepLinkType {
    static func from(name _: String, parameters _: [String: String]) -> DeepLinkType? {
//        switch name {
//        case let s where s == "EmailCertification":
//            if let id = parameters["id"],
//               let email = parameters["email"]
//            {
//                return .emailCertification(hashedUUID: id, email: email)
//            }
//        default: break
//        }
        return nil
    }
}
