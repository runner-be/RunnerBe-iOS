//
//  Gender.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation

enum Gender: CaseIterable {
    case none
    case male
    case female
}

extension Gender {
    var code: String {
        switch self {
        case .male:
            return "M"
        case .female:
            return "F"
        case .none:
            return "A"
        }
    }

    init(idx: Int) {
        if idx >= 0, idx < Gender.allCases.count {
            self = Gender.allCases[idx]
            return
        }
        self = .none
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

    init(name: String) {
        for gender in Gender.allCases {
            if gender.name == name {
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
            return L10n.Gender.none
        }
    }
}
