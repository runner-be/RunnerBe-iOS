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
    let runnedDate: String
    let stampCode: String
}
