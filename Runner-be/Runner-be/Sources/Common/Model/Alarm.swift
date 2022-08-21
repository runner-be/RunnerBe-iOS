//
//  Alarm.swift
//  Runner-be
//
//  Created by 김신우 on 2022/08/21.
//

import Foundation
import SwiftyJSON

struct Alarm {
    let alarmID: Int
    let userID: Int
    let createdAt: Date
    let title: String
    let content: String
    let isNew: Bool

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
