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
    func changeFormat(_ text: String, from: DateFormat, to: DateFormat) -> String?
    func getRange(format: DateFormat, startDate: Date, dayOffset: Int) -> [String]
    func getTimeObject(string: String, format: DateFormat) -> TimeObject?
    var currentTimeObject: TimeObject { get }
}

enum DateFormat {
    case yyyy // yyyy
    case yyyyMMddHHmmss // yyyy-MM-dd HH:mm:ss 서버 전달용
    case HHmm // HH:mm 서버 전달용
    case yyyyMdEahmm // 월/일 (요일) AM/PM 6:00
    case MdE // 월/일 (요일)
    case korHmm // ~시간 ~분
    case gathering // 00/00(화) AM00:00
    case running // 약 ~시간 ~분
    case custom(format: String, missingParts: [DatePart])
}

enum DatePart {
    case year, month, day, hour, minute, second
}

extension DateFormat {
    var formatString: String {
        switch self {
        case .yyyy:
            return "yyyy"
        case .yyyyMMddHHmmss:
            return "yyyy-MM-dd HH:mm:ss"
        case .HHmm:
            return "HH:mm"
        case .yyyyMdEahmm:
            return "yyyy M/d (E) a h:mm"
        case .MdE:
            return "M/d (E)"
        case .korHmm:
            return "h시간 mm분"
        case .gathering:
            return "M/d(e) ahh:mm"
        case .running:
            return "약 h시간mm분"
        case let .custom(format, _):
            return format
        }
    }

    var missingParts: [DatePart] {
        switch self {
        case .yyyy:
            return [.month, .day, .hour, .minute, .second]
        case .yyyyMMddHHmmss:
            return []
        case .HHmm:
            return [.year, .month, .day, .second]
        case .yyyyMdEahmm:
            return []
        case .MdE:
            return [.month, .day]
        case .korHmm:
            return [.hour, .minute]
        case .gathering:
            return [.year, .second]
        case .running:
            return [.hour, .minute]
        case let .custom(_, parts):
            return parts
        }
    }
}
