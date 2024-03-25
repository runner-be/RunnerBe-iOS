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
    case none
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
        case .none:
            return ""
        }
    }

    var image: UIImage? {
        switch self {
        case .beginner:
            return Asset.runningPaceBeginner.image
        case .average:
            return Asset.runningPaceAverage.image
        case .high:
            return Asset.runningPaceHigh.image
        case .master:
            return Asset.runningPaceMaster.image
        case .none:
            return nil
        }
    }
}
