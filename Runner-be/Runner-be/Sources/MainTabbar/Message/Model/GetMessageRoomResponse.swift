//
//  GetMessageRoomResponse.swift
//  Runner-be
//
//  Created by 이유리 on 2022/08/06.
//

import Foundation

// MARK: - Welcome

struct GetMessageRoomResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: GetMessageRoomInfoResult?
}

// MARK: - Result

struct GetMessageRoomInfoResult: Decodable {
    let roomInfo: [RoomInfo]?
    let messageList: [MessageContent]?
}

// MARK: - MessageList

struct MessageContent: Decodable {
    let messageId: Int?
    let content: String?
    let imageUrl: String?
    let createdAt: String?
    let userID: Int?
    let nickName: String?
    let profileImageURL: String?
    let messageFrom: String?
    let whetherPostUser: String?
}

// MARK: - RoomInfo

struct RoomInfo: Decodable {
    let postId: Int?
    let pace, title: String?
}
