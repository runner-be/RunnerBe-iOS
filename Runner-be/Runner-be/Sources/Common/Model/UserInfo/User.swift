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
    let pushOn: String
    let job: String
    let profileImageURL: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickName, gender, age, diligence, job
        case pushOn
        case profileImageURL = "profileImageUrl"
    }
}

struct UserResponse: Decodable {
    let userID: Int
    let nickName, gender, age, diligence: String
    let job: String
    let profileImageURL: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickName, gender, age, diligence, job
        case profileImageURL = "profileImageUrl"
    }

    var userInfo: User {
        User(userID: userID,
             nickName: nickName,
             gender: gender,
             age: age,
             diligence: diligence,
             pushOn: "Y",
             job: job,
             profileImageURL: profileImageURL)
    }
}
