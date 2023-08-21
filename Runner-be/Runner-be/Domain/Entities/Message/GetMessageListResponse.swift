//
//  GetMessageResponse.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/21.
//

import Foundation

// MARK: - Welcome

struct GetMessageListResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [MessageRoom]?
}

// MARK: - Result

struct MessageRoom: Decodable {
    let roomId: Int?
    let title, repUserName: String?
    let profileImageUrl: String?
    let recentMessage: String?

    enum CodingKeys: String, CodingKey {
        case roomId
        case title, repUserName
        case profileImageUrl
        case recentMessage
    }
}
