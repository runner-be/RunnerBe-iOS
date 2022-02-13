//
//  Gender.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation

enum Gender: CaseIterable {
    case male
    case female
    case none
}

extension Gender {
    var code: String {
        switch self {
        case .male:
            return "M"
        case .female:
            return "F"
        case .none:
            return ""
        }
    }

    init(code: String) {
        for gender in Gender.allCases {
            if gender.code == code {
                self = gender
                return
            }
        }
        self = .none
    }

    var name: String {
        switch self {
        case .male:
            return L10n.Gender.male
        case .female:
            return L10n.Gender.female
        case .none:
            return ""
        }
    }
}
