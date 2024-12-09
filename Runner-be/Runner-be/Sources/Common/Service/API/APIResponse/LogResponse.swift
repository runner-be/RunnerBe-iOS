//
//  LogResponse.swift
//  Runner-be
//
//  Created by 김창규 on 9/7/24.
//

import Foundation

// 마이페이지에서 사용되는 LogResponse
struct LogResponse: Decodable {
    let totalCount: LogTotalCount
    let myRunningLog: [MyRunningLog]
    let isExistGathering: [ExistingGathering]

    enum CodingKeys: String, CodingKey {
        case totalCount
        case myRunningLog
        case isExistGathering
    }
}

// 타인 유저페이지에서 사용되는 LogResponse
struct UserLogResponse: Decodable {
    let totalCount: LogTotalCount
    let userLogInfo: [MyRunningLog]

    enum CodingKeys: String, CodingKey {
        case totalCount
        case userLogInfo
    }
}

struct LogTotalCount: Decodable {
    let groupRunningCount: Int
    let personalRunningCount: Int
}

struct MyRunningLog: Decodable {
    let logId: Int?
    let gatheringId: Int?
    let runnedDate: String
    let stampCode: String?
    let isOpened: Int?

    var isFuture: Bool {
        // 현재 날짜와 시간을 가져옴
        let currentDate = Date()

        // runnedDate를 Date 객체로 변환
        if let runDate = runnedDate.toDate() {
            return runDate > currentDate
        }

        // 만약 날짜 변환에 실패한 경우, 기본적으로 미래가 아니라고 간주
        return false
    }
}

struct ExistingGathering: Decodable {
    var gatheringId: Int
    var gatheringTime: String
}

extension ExistingGathering {
    var date: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return Date()
    }
}
