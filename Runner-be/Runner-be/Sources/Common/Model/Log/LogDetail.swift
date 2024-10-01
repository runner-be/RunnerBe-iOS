//
//  LogDetail.swift
//  Runner-be
//
//  Created by 김창규 on 9/20/24.
//
import Foundation

struct DetailRunningLog: Decodable {
    let status: String
    let runnedDate: String
    let userId: Int
    let gatheringId: Int?
    let stampCode: String
    let contents: String?
    let imageUrl: String?
    let weatherDegree: Int
    let weatherIcon: String
    let isOpened: Int
}

struct GotStamp: Decodable {
    let userId: Int
    let logId: Int?
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

    var runningDate: Date? {
        guard let detailRunningLog = detailRunningLog else {
            return nil
        }
        let isoDateFormatter = DateFormatter()
        isoDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        isoDateFormatter.locale = Locale(identifier: "ko_KR") // 한국어 Locale 설정
        isoDateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Z가 GMT 0을 의미하므로, TimeZone을 맞춰줍니다.
        return isoDateFormatter.date(from: detailRunningLog.runnedDate)
    }

    // ex) 2024년 09월 23일 월요일
    var runningDateString: String? {
        guard let detailRunningLog = detailRunningLog else {
            return nil
        }

        let isoDateFormatter = DateFormatter()
        isoDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        isoDateFormatter.locale = Locale(identifier: "ko_KR") // 한국어 Locale 설정
        isoDateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Z가 GMT 0을 의미하므로, TimeZone을 맞춰줍니다.

        if let date = isoDateFormatter.date(from: detailRunningLog.runnedDate) {
            // 3. 원하는 형식으로 변환하기 위한 DateFormatter
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "yyyy년 MM월 dd일 EEEE"
            outputDateFormatter.locale = Locale(identifier: "ko_KR") // 한국어 요일 표기를 위한 Locale 설정

            // 4. Date를 원하는 형식으로 변환하여 출력
            let formattedDate = outputDateFormatter.string(from: date)
            return formattedDate // 출력: 2024년 07월 05일 금요일
        }

        return nil
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
