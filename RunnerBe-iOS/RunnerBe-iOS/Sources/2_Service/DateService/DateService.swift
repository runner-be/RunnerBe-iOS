//
//  DateService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation

protocol DateService {
    func getCurrent(format: DateFormat) -> String
    var defaultYear: Int { get }
}

enum DateFormat {
    case yyyy
}

extension DateFormat {
    var formatString: String {
        switch self {
        case .yyyy:
            return "yyyy"
        }
    }
}
