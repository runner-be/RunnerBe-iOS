//
//  DateService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/01.
//

import Foundation

class DateUtil {
    static let shared = DateUtil()
    private init() {
        dateFormatter = DateFormatter()
    }

    let dateFormatter: DateFormatter
    var defaultYear = 2022

    func getCurrent(format: DateFormat) -> String {
        dateFormatter.dateFormat = format.formatString
        return dateFormatter.string(from: Date())
    }

    func changeFormat(_ text: String, from: DateFormat, to: DateFormat) -> String? {
        dateFormatter.dateFormat = from.formatString
        guard let date = dateFormatter.date(from: text)
        else { return nil }

        dateFormatter.dateFormat = to.formatString
        return dateFormatter.string(from: date)
    }

    func getFormattedDateArray(format: DateFormat, startDate: Date = Date(), dayOffset: Int) -> [String] {
        dateFormatter.dateFormat = format.formatString

        var dateArr = [String]()
        for offset in 0 ..< dayOffset {
            let date = startDate.addingTimeInterval(TimeInterval(86400 * Double(offset))) // 86400 하루
            dateArr.append(dateFormatter.string(from: date))
        }

        return dateArr
    }

    func formattedString(for date: Date, format: DateFormat, localeId: String = L10n.locale) -> String {
        let oldLocale = dateFormatter.locale
        defer { dateFormatter.locale = oldLocale }

        dateFormatter.locale = Locale(identifier: localeId)
        dateFormatter.dateFormat = format.formatString

        return dateFormatter.string(from: date)
    }
}
