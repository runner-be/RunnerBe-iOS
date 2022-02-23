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
}

enum DateFormat {
    case yyyy // yyyy
    case yyyyMMddHHmmss // yyyy-MM-dd HH:mm:ss 서버 전달용
    case HHmm // HH:mm 서버 전달용
    case yyyyMdEahmm // 월/일 (요일) AM/PM 6:00
    case MdE // 월/일 (요일)
    case korHmm // ~시간 ~분
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
            return "h 시간 mm 분"
        }
    }
}
