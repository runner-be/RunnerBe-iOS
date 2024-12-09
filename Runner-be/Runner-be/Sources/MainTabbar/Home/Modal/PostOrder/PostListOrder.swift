//
//  PostListOrder.swift
//  Runner-be
//
//  Created by 김신우 on 2022/07/27.
//

import Foundation

enum PostListOrder {
    case distance, latest
}

extension PostListOrder {
    var text: String {
        switch self {
        case .distance:
            return "거리순"
        case .latest:
            return "최신순"
        }
    }

    var filterType: FilterType {
        switch self {
        case .distance:
            return FilterType.distance
        case .latest:
            return FilterType.newest
        }
    }
}
