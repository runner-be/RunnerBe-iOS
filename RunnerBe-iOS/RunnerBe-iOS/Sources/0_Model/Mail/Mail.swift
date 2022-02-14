//
//  Mail.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/15.
//

import Foundation

struct Mails: Codable {
    let mails: [Mail]

    enum CodingKeys: String, CodingKey {
        case mails = "Messages"
    }
}

struct Mail: Codable {
    let from: MailAddress
    let to: [MailAddress]
    let subject: String
    let textPart: String?
    let htmlPart: String?

    enum CodingKeys: String, CodingKey {
        case from = "From"
        case to = "To"
        case subject = "Subject"
        case textPart = "TextPart"
        case htmlPart = "HTMLPart"
    }
}

struct MailAddress: Codable {
    let email: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case email = "Email"
        case name = "Name"
    }
}
