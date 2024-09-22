//
//  LogDetail.swift
//  Runner-be
//
//  Created by 김창규 on 9/20/24.
//

struct DetailRunningLog: Decodable {
    let status: String
    let runnedDate: String
    let userId: Int
    let stampCode: String
    let contents: String?
    let imageUrl: String?
    let weatherDegree: Int
    let weatherIcon: String
    let isOpened: Int
}

struct GotStamp: Decodable {
    let userId: Int
    let nickname: String
    let profileImageUrl: String?
    let stampCode: String
}

struct LogDetail: Decodable {
    let gotStamp: [GotStamp]
    let gatheringCount: Int
    let detailRunningLogs: [DetailRunningLog]

    enum CodingKeys: String, CodingKey {
        case gotStamp
        case gatheringCount
        case detailRunningLogs = "detailRunningLog"
    }

    var detailRunningLog: DetailRunningLog? {
        detailRunningLogs.first
    }

    var runningStamp: StampType? {
        StampType(rawValue: detailRunningLog?.stampCode ?? "")
    }

    var weatherStamp: StampType? {
        StampType(rawValue: detailRunningLog?.weatherIcon ?? "")
    }

    var weatherDegree: String {
        if let weatherDegree = detailRunningLog?.weatherDegree {
            return "\(weatherDegree)"
        } else {
            return "-"
        }
    }

    var contents: String? {
        detailRunningLog?.contents
    }

    var imageURL: String {
        detailRunningLog?.imageUrl ?? ""
    }

    var isOpened: Bool {
        detailRunningLog?.isOpened == 1
    }
}
