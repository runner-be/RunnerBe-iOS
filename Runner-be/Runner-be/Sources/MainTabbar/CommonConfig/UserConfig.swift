//
//  UserConfig.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import Foundation
import RxDataSources

struct UserConfig: Equatable, IdentifiableType {
    let userId: Int
    let nickName: String
    let age: String
    let gender: String
    let job: String
    let isPostOwner: Bool
    let pushOn: String?
    let diligence: String
    let profileURL: String?
    let pace: String?

    init(from user: User, owner: Bool) {
        userId = user.userID
        nickName = user.nickName
        age = user.age
        gender = user.gender
        job = user.job
        pushOn = user.pushOn
        isPostOwner = owner
        profileURL = user.profileImageURL
        diligence = user.diligence
        pace = user.pace
    }

    init(name: String) {
        nickName = name
        age = "~~대 초반"
        gender = "전체"
        job = "개발"
        isPostOwner = false
        profileURL = nil
        diligence = "초보 출석"
        pushOn = "N"
        pace = nil
        userId = 0
    }

    var identity: String { nickName }
}
