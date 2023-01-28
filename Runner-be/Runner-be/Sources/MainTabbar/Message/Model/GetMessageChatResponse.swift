//
//  GetMessageChatResponse.swift
//  Runner-be
//
//  Created by 이유리 on 2022/08/06.
//

import Foundation

// MARK: - Welcome

struct GetMessageChatResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: GetMessageChatResult?
}

// MARK: - Result

struct GetMessageChatResult: Decodable {
    let roomInfo: [RoomInfo]?
    let messageList: [MessageContent]?
}

// MARK: - MessageList

struct MessageContent: Decodable {
    let messageId: Int?
    let content, createdAt: String?
    let userID: Int?
    let nickName: String?
    let profileImageURL: String?
    let messageFrom, whetherPostUser: String?
}

// MARK: - RoomInfo

struct RoomInfo: Decodable {
    let postId: Int?
    let runningTag, title: String?
}
