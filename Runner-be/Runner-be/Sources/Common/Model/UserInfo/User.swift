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
    var whetherCheck: String? // Y , N
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

// 출석 관리하기도 마찬가지로 해당 API가 없고,
// 마이페이지API를 사용하고 있었기 때문에 게시글 상세보기 API를 사용한 데이터타입을 정의합니다.
struct ManageAttendance {
    let currentDate: Date
    let gatherDate: Date
    let runningTime: (hour: Int, minute: Int)

    var currentInterval: TimeInterval {
        currentDate.timeIntervalSince1970
    }

    var gatherIOnterval: TimeInterval {
        gatherDate.timeIntervalSince1970
    }

    var runningInterval: TimeInterval {
        TimeInterval(runningTime.hour * 60 * 60 + runningTime.minute * 60)
    }

    var attendanceTimeLimit: Double = (3 * 60 * 60)

    // FIXME: 202.11.21 마이페이지에서 이미 계산된 데이터
    // 마이페이지에서 이미 출석마감상태를 가지고 있다.
    // 이 데이터타입을 사용하는 곳에서 마이페이지에 가지고있는 출석상태를 사용하여
    // 불필요한 계산을 삭제하자, 기존 코드 호환성으로 인해 추가했습니다.
    var attendTimeOver: Bool {
        return currentInterval > (gatherIOnterval + runningInterval + attendanceTimeLimit) // 모임 시작 후 출석 마감이 되었는가?
    }

    let attendanceList: [RunnerInfo]
}
