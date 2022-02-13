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
    }

    var defaultYear: Int { 2022 }

    func getCurrent(format: DateFormat) -> String {
        let date = Date()
        dateFormatter.dateFormat = format.formatString
        return dateFormatter.string(from: date)
    }
}
