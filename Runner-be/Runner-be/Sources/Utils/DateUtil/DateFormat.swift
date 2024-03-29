//
//  DateFormat.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/01.
//

import Foundation

enum DateFormat {
    case apiDate
    case apiDateTimeZoneRemoved
    case apiTime
    case yyyy // yyyy
    case yyyyMMddHHmmss // yyyy-MM-dd HH:mm:ss 서버 전달용
    case HHmm // HH:mm 서버 전달용
    case yyyyMdEahmm // 년 월/일 (요일) AM/PM 6:00
    case MdE // 월/일 (요일)
    case posting
    case mdeahhmmSpacing
    case korHmm // ~시간 ~분
    case gathering // 00/00(화) AM00:00
    case running // 약 ~시간 ~분
    case ampm // am, pm
    case Hmm // 6:00
    case custom(format: String)
    case messageTime
}

extension DateFormat {
    var formatString: String {
        switch self {
        case .apiDate:
            return "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        case .apiDateTimeZoneRemoved:
            return "yyyy-MM-dd'T'HH:mm:ss"
        case .apiTime:
            return "hh:mm:ss"
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
        case .mdeahhmmSpacing:
            return "M/d (E) a hh:mm"
        case .posting:
            return "yyyy M/d (E) a hh:mm"
        case .gathering:
            return "M/d(E) ahh:mm"
        case .ampm:
            return "a"
        case .Hmm:
            return "H:mm"
        case .running:
            return "약 h시간mm분"
        case let .custom(format):
            return format
        case .messageTime:
            return "M/dd"
        }
    }
}
