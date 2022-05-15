//
//  GetBookMarkResponse.swift
//  Runner-be
//
//  Created by 이유리 on 2022/05/15.
//

import Foundation

struct GetBookMarkResponse: Decodable {
    let postID: Int?
    let postUserID: Int?
    let postingTime: String? // 작성 시간

    // 작성자 정보
    let nickName: String?
    let profileImageURL: String?

    let title: String?
    let runningTime: String? // "01:30:00"
    let gatheringTime: String? // "2022-02-23T19:49:39.000z"
    let gatherLongitude: String?
    let gatherLatitude: String?
    let locationInfo: String?
    let runningTag: String?
    let age: String?
    let gender: String?
    let whetherEnd: String?
    let job: String?
    let peopleNum: Int?
    let contents: String?
    let userID: Int?
    let bookMark: Int?
    let attendance: Int?
    let distance: String?
    let profileURLList: [ProfileURL]?

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case postingTime
        case postUserID = "postUserId"
        case nickName
        case profileImageURL = "profileImageUrl"
        case title
        case runningTime
        case gatheringTime
        case gatherLongitude
        case gatherLatitude
        case locationInfo
        case runningTag
        case age
        case gender
        case whetherEnd
        case job
        case peopleNum
        case contents
        case userID = "userId"
        case bookMark
        case attendance
        case distance = "DISTANCE"
        case profileURLList = "profileUrlList"
    }
}

struct bookMarkNum {
    let num: String?
}
