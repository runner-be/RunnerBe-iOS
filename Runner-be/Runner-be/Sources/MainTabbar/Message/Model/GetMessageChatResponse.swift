//
//  GetMessageChatResponse.swift
//  Runner-be
//
//  Created by 이유리 on 2022/08/06.
//

import Foundation

// MARK: - Welcome

struct GetMessageChatResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: GetMessageChatResult?
}

// MARK: - Result

struct GetMessageChatResult: Codable {
    let roomInfo: [RoomInfo]?
    let messageList: [MessageList]?
}

// MARK: - MessageList

struct MessageList: Codable {
    let messageID: Int?
    let content, createdAt: String?
    let userID: Int?
    let nickName: String?
    let profileImageURL: String?
    let messageFrom, whetherPostUser: String?
}

// MARK: - RoomInfo

struct RoomInfo: Codable {
    let runningTag, title: String?
}
