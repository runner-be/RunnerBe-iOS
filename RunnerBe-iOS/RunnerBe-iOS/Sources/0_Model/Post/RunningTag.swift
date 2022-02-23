//
//  RunningTag.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/23.
//

import Foundation

enum RunningTag: CaseIterable {
    case beforeWork, afterWork, dayoff, error
}

extension RunningTag {
    var code: String {
        switch self {
        case .beforeWork:
            return "B"
        case .afterWork:
            return "A"
        case .dayoff:
            return "H"
        case .error:
            return ""
        }
    }

    var name: String {
        switch self {
        case .beforeWork:
            return L10n.Post.WorkTime.beforeWork
        case .afterWork:
            return L10n.Post.WorkTime.afterWork
        case .dayoff:
            return L10n.Post.WorkTime.dayOff
        case .error:
            return ""
        }
    }

    static func isValid(_ idx: Int) -> Bool {
        return idx < (RunningTag.allCases.count - 1)
    }

    init(code: String) {
        for tag in RunningTag.allCases {
            if tag.code == code {
                self = tag
                return
            }
        }
        self = .error
    }

    init(name: String) {
        for tag in RunningTag.allCases {
            if tag.name == name {
                self = tag
                return
            }
        }
        self = .error
    }
}
