//
//  RunningPace.swift
//  Runner-be
//
//  Created by 이유리 on 2/25/24.
//

import UIKit

enum RunningPace: String {
    case beginner
    case average
    case high
    case master
}

extension RunningPace {
    var value: String {
        switch self {
        case .beginner:
            return "700 ~ 900"
        case .average:
            return "600 ~ 700"
        case .high:
            return "430 ~ 600"
        case .master:
            return "430 이하"
        }
    }

    var image: UIImage {
        switch self {
        case .beginner:
            return .runningPaceBeginner
        case .average:
            return .runningPaceAverage
        case .high:
            return .runningPaceHigh
        case .master:
            return .runningPaceMaster
        }
    }
}
