//
//  PostState.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/23.
//

import Foundation

enum PostState: CaseIterable {
    case open, closed, error
}

extension PostState {
    var code: String {
        switch self {
        case .open:
            return "N"
        case .closed:
            return "Y"
        case .error:
            return ""
        }
    }

    init(from code: String) {
        for state in PostState.allCases {
            if state.code == code {
                self = state
                return
            }
        }
        self = .error
    }
}
