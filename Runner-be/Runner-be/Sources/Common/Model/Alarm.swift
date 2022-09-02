//
//  Alarm.swift
//  Runner-be
//
//  Created by 김신우 on 2022/08/21.
//

import Foundation
import SwiftyJSON

struct Alarm: Decodable {
    let alarmID: Int
    let userID: Int
    let createdAt: Date
    let title: String
    let content: String
    var isNew: Bool

    enum CodingKeys: String, CodingKey {
        case alarmID = "alarmId"
        case userID = "userId"
        case createdAt
        case title
        case content
        case whetherRead
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        alarmID = try container.decode(Int.self, forKey: .alarmID)
        userID = try container.decode(Int.self, forKey: .userID)
        title = try container.decode(String.self, forKey: .title)
        content = try container.decode(String.self, forKey: .content)
        let whetherRead = try container.decode(String.self, forKey: .whetherRead)
        let dateString = try container.decode(String.self, forKey: .createdAt)
        isNew = whetherRead == "N"

        let formatter = DateUtil.shared.dateFormatter
        formatter.dateFormat = DateFormat.apiDate.formatString
        var date = formatter.date(from: dateString)
        date = date?.addingTimeInterval(TimeInterval(-TimeZone.current.secondsFromGMT()))
        guard let createdAt = date else {
            throw JSONError.error("Json Decoding Error")
        }
        self.createdAt = createdAt
    }

    init(json: JSON) throws {
        guard let alarmID = json["alarmId"].int,
              let userID = json["userId"].int,
              let createdAtString = json["createdAt"].string,
              let title = json["title"].string,
              let content = json["content"].string,
              let isNew = json["whetherRead"].string
        else {
            Log.e("Parsing Alarm")
            throw JSONError.error("Json Decoding Error")
        }

        let formatter = DateUtil.shared.dateFormatter
        formatter.dateFormat = DateFormat.apiDate.formatString
        var date = formatter.date(from: createdAtString)
        date = date?.addingTimeInterval(TimeInterval(-TimeZone.current.secondsFromGMT()))
        guard let createdAt = date else {
            throw JSONError.error("Json Decoding Error")
        }

        self.createdAt = createdAt
        self.alarmID = alarmID
        self.userID = userID
        self.title = title
        self.content = content
        self.isNew = isNew == "Y"
    }

    init(alarmID: Int, userID: Int, createdAt: Double, title: String, content: String, isNew: Bool) {
        self.alarmID = alarmID
        self.userID = userID
        self.createdAt = Date(timeIntervalSince1970: Date().timeIntervalSince1970 - createdAt)
        self.title = title
        self.content = content
        self.isNew = isNew
    }
}
