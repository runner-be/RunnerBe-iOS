//
//  BasicDateService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation

final class BasicDateService: DateService {
    let dateFormatter: DateFormatter

    init(dateFormatter: DateFormatter = DateFormatter()) {
        self.dateFormatter = dateFormatter
        dateFormatter.locale = Locale(identifier: L10n.locale)
    }

    var defaultYear: Int { 2022 }

    func getCurrent(format: DateFormat) -> String {
        let date = Date()
        dateFormatter.dateFormat = format.formatString
        return dateFormatter.string(from: date)
    }

    func changeFormat(_ text: String, from: DateFormat, to: DateFormat) -> String? {
        dateFormatter.dateFormat = from.formatString
        guard let date = dateFormatter.date(from: text)
        else { return nil }

        dateFormatter.dateFormat = to.formatString
        return dateFormatter.string(from: date)
    }

    func getRange(format: DateFormat, startDate: Date = Date(), dayOffset: Int) -> [String] {
        dateFormatter.dateFormat = format.formatString

        var dateArr = [String]()
        for offset in 0 ..< dayOffset {
            let date = startDate.addingTimeInterval(TimeInterval(86400 * Double(offset))) // 86400 하루
            dateArr.append(dateFormatter.string(from: date))
        }

        return dateArr
    }
}
