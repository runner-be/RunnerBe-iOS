//
//  AfterParty.swift
//  Runner-be
//
//  Created by 김창규 on 10/29/24.
//

import Foundation

enum AfterPartyFilter: CaseIterable {
    case all
    case yes
    case no
}

extension AfterPartyFilter {
    var code: String {
        switch self {
        case .all:
            return "A"
        case .yes:
            return "Y"
        case .no:
            return "N"
        }
    }

    var index: Int {
        var idx = 0
        for (i, j) in AfterPartyFilter.allCases.enumerated() {
            idx = i
            if self == j {
                return i
            }
        }
        return idx
    }

    init(idx: Int) {
        if idx >= 0, idx < Job.allCases.count {
            self = AfterPartyFilter.allCases[idx]
            return
        }
        self = .all
    }
}
