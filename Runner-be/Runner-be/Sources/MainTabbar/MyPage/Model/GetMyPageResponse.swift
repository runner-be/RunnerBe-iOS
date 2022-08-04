//
//  GetMyPageResponse.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/21.
//

import Foundation

// MARK: - Welcome

struct GetMyPageResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: GetMyPageResult?
}

// MARK: - Result

struct GetMyPageResult: Codable {
    let myInfo: [MyInfo]?
    let myPosting: [MyPosting]?
    let myRunning: [MyRunning]?
}

// MARK: - MyInfo

struct MyInfo: Codable {
    let userID: Int?
    let nickName, gender, age, diligence: String?
    let job: String?
    let profileImageURL: String?
    let pushOn, nameChanged: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickName, gender, age, diligence, job
        case profileImageURL = "profileImageUrl"
        case pushOn, nameChanged
    }
}

// MARK: - MyPosting

struct MyPosting: Codable {
    let postID: Int?
    let postingTime: String?
    let postUserID: Int?
    let nickName: String?
    let profileImageURL: String?
    let title, runningTime, gatheringTime, gatherLongitude: String?
    let gatherLatitude, locationInfo, runningTag, age: String?
    let gender, whetherEnd, job: String?
    let peopleNum: Int?
    let contents: String?
    let userID, bookMark: Int?
    let distance: String?
    let attendance: Int?
    let profileURLList: [ProfileURLList]?
    let runnerList: [RunnerList]?

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case postingTime
        case postUserID = "postUserId"
        case nickName
        case profileImageURL = "profileImageUrl"
        case title, runningTime, gatheringTime, gatherLongitude, gatherLatitude, locationInfo, runningTag, age, gender, whetherEnd, job, peopleNum, contents
        case userID = "userId"
        case bookMark
        case distance = "DISTANCE"
        case attendance
        case profileURLList = "profileUrlList"
        case runnerList
    }
}

// MARK: - ProfileURLList

struct ProfileURLList: Codable {
    let userID: Int?
    let profileImageURL: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case profileImageURL = "profileImageUrl"
    }
}

// MARK: - RunnerList

struct RunnerList: Codable {
    let userID: Int?
    let nickName, gender, age, diligence: String?
    let job: String?
    let profileImageURL: String?
    let whetherCheck: String?
    let attendance: Int?
    let whetherPostUser: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickName, gender, age, diligence, job
        case profileImageURL = "profileImageUrl"
        case whetherCheck, attendance, whetherPostUser
    }
}

// MARK: - MyRunning

struct MyRunning: Codable {
    let postID: Int?
    let postingTime: String?
    let postUserID: Int?
    let nickName: String?
    let profileImageURL: String?
    let title, runningTime, gatheringTime, gatherLongitude: String?
    let gatherLatitude, locationInfo, runningTag, age: String?
    let gender, whetherEnd, job: String?
    let peopleNum: Int?
    let contents: String?
    let userID, bookMark, attendance: Int?
    let whetherCheck: String?
    let distance: Int?
    let profileURLList: [ProfileURLList]?

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case postingTime
        case postUserID = "postUserId"
        case nickName
        case profileImageURL = "profileImageUrl"
        case title, runningTime, gatheringTime, gatherLongitude, gatherLatitude, locationInfo, runningTag, age, gender, whetherEnd, job, peopleNum, contents
        case userID = "userId"
        case bookMark, attendance, whetherCheck
        case distance = "DISTANCE"
        case profileURLList = "profileUrlList"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    public static func == (_: JSONNull, _: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
