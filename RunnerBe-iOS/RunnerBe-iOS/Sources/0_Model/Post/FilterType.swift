//
//  FilterType.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/23.
//

import Foundation

enum FilterType: CaseIterable {
    case distance, bookmarks, newest, error
}

extension FilterType {
    var code: String {
        switch self {
        case .distance:
            return "D"
        case .bookmarks:
            return "B"
        case .newest:
            return "R"
        case .error:
            return ""
        }
    }

    init(from code: String) {
        for state in FilterType.allCases {
            if state.code == code {
                self = state
                return
            }
        }
        self = .error
    }
}
