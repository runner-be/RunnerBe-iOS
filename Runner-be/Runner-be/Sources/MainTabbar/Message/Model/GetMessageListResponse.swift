//
//  GetMessageResponse.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/21.
//

import Foundation

// MARK: - Welcome

struct GetMessageListResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [GetMessageListResult]?
}

// MARK: - Result

struct GetMessageListResult: Codable {
    let roomID: Int?
    let title, repUserName: String?
    let profileImageUrl: String?
    let recentMessage: String?

    enum CodingKeys: String, CodingKey {
        case roomID
        case title, repUserName
        case profileImageUrl
        case recentMessage
    }
}
