//
//  TimeObject.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/28.
//

import Foundation

struct TimeObject: CustomStringConvertible {
    let date: Date
    var year: Int
    var month: Int
    var day: Int
    var hour: Int
    var minute: Int
    var second: Int

    init(date: Date, formatter: DateFormatter) {
        formatter.dateFormat = "yyyy,MM,dd,HH,mm,ss"
        let dateComponents = formatter.string(from: date).components(separatedBy: ",")

        self.date = date
        year = Int(dateComponents[0]) ?? 2022
        month = Int(dateComponents[1]) ?? 1
        day = Int(dateComponents[2]) ?? 1
        hour = Int(dateComponents[3]) ?? 0
        minute = Int(dateComponents[4]) ?? 0
        second = Int(dateComponents[5]) ?? 0
    }

    init?(string: String, format: DateFormat, formatter: DateFormatter) {
        formatter.dateFormat = format.formatString

        guard let date = formatter.date(from: string)
        else { return nil }

        formatter.dateFormat = "yyyy,M,d,H,m,s"
        let dateComponents = formatter.string(from: date).components(separatedBy: ",")
        year = Int(dateComponents[0]) ?? 2000
        month = Int(dateComponents[1]) ?? 1
        day = Int(dateComponents[2]) ?? 1
        hour = Int(dateComponents[3]) ?? 0
        minute = Int(dateComponents[4]) ?? 0
        second = Int(dateComponents[5]) ?? 0

        for missingPart in format.missingParts {
            switch missingPart {
            case .year:
                year = 2022
            case .month:
                month = 1
            case .day:
                day = 1
            case .hour:
                hour = 0
            case .minute:
                minute = 0
            case .second:
                second = 0
            }
        }

        formatter.dateFormat = "y,M,d,h,m,s"
        let dateString = "\(year),\(month),\(day),\(hour),\(minute),\(second)"

        if let d = formatter.date(from: dateString) {
            self.date = d
        } else {
            return nil
        }
    }

    func getDate(formatter: DateFormatter) -> Date? {
        formatter.dateFormat = "y,M,d,h,m,s"
        let dateString = "\(year),\(month),\(day),\(hour),\(minute),\(second)"

        return formatter.date(from: dateString)
    }

    var description: String {
        "part: \(year).\(month).\(day) \(hour):\(minute):\(second)"
    }
}
