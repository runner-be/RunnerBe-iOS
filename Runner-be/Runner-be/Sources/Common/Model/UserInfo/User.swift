//
//  User.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/26.
//

import Foundation

struct User: Codable {
    let userID: Int
    let nickName, gender, age, diligence: String
    let pushOn: String?
    let job: String
    let profileImageURL: String?
    var nameChanged, jobChangePossible: String?
    var pace: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickName, gender, age, diligence, job
        case pushOn
        case profileImageURL = "profileImageUrl"
        case nameChanged, jobChangePossible, pace
    }
}

struct UserResponse: Decodable {
    let userID: Int
    let nickName, gender, age, diligence: String
    let job: String
    let profileImageURL: String?
    var nameChanged, jobChangePossible: String?
    var pace: String?
    var attendance: Int?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickName, gender, age, diligence, job
        case profileImageURL = "profileImageUrl"
        case nameChanged, jobChangePossible, pace
        case attendance
    }

    var userInfo: User {
        User(userID: userID,
             nickName: nickName,
             gender: gender,
             age: age,
             diligence: diligence,
             pushOn: "Y",
             job: job,
             profileImageURL: profileImageURL,
             pace: pace)
    }
}

// (2024.11.15) 출석 확인하기 API가 존재하지 않아 게시글상세보기 API를 사용하여
// 받은 데이터 중 runnerinfo 데이터의 attendance 정보를 사용합니다.
// 출석확인하기 API가 추가되면 아래 코드는 삭제 또는 변경이 필요합니다.
struct RunnerInfo: Decodable {
    let userID: Int
    let nickName, gender, age, diligence: String
    let job: String
    let profileImageURL: String?
    var nameChanged, jobChangePossible: String?
    var pace: String?
    var attendance: Int?
    var whetherPostUser: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickName, gender, age, diligence, job
        case profileImageURL = "profileImageUrl"
        case nameChanged, jobChangePossible, pace
        case attendance
        case whetherPostUser
    }
}
