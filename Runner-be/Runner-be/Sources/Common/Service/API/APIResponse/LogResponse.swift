//
//  LogResponse.swift
//  Runner-be
//
//  Created by 김창규 on 9/7/24.
//

import Foundation

struct LogResponse: Decodable {
    let totalCount: LogTotalCount
    let myRunningLog: [MyRunningLog]

    enum CodingKeys: String, CodingKey {
        case totalCount
        case myRunningLog
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

    var isFuture: Bool {
        // 현재 날짜와 시간을 가져옴
        let currentDate = Date()

        // ISO8601DateFormatter 인스턴스 생성
        let isoFormatter = ISO8601DateFormatter()

        // runnedDate를 Date 객체로 변환
        if let runDate = runnedDate.toDate() {
            return runDate > currentDate
        }

        // 만약 날짜 변환에 실패한 경우, 기본적으로 미래가 아니라고 간주
        return false
    }
}
