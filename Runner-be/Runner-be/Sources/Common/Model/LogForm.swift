//
//  LogForm.swift
//  Runner-be
//
//  Created by 김창규 on 9/5/24.
//

import Foundation

struct LogForm {
    let runningDate: Date
    var logId: Int?
    var gatheringId: Int?
    var stampCode: String?
    var contents: String?
    var imageUrl: String?
    var imageData: Data?
    var weatherDegree: Int?
    var weatherIcon: String?
    var isOpened: Int

    var isPersonalLog: Bool {
        return gatheringId == nil
    }
}

extension LogForm: Encodable {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(runningDate, forKey: .runningDate)
        try container.encode(logId, forKey: .gatheringId)
        try container.encode(stampCode, forKey: .stampCode)
        try container.encode(contents, forKey: .contents)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(weatherDegree, forKey: .weatherDegree)
        try container.encode(weatherIcon, forKey: .weatherIcon)
        try container.encode(isOpened, forKey: .isOpened)
    }

    enum CodingKeys: CodingKey {
        case runningDate
        case gatheringId
        case stampCode
        case contents
        case imageUrl
        case weatherDegree
        case weatherIcon
        case isOpened
    }
}

extension LogForm: CustomDebugStringConvertible {
    var debugDescription: String {
        """
        LogForm {
        runningDate: \(runningDate)
        logId: \(logId ?? 0)
        stampCode: \(stampCode ?? "nil")
        contents: \(contents ?? "nil")
        imageUrl: \(imageUrl ?? "nil")
        weatherDegree: \(weatherDegree ?? 0)
        weatherIcon: \(weatherIcon ?? "nil")
        isOpened: \(isOpened)
        }
        """
    }
}
