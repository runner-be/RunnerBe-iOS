//
//  Job.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation

enum Job: CaseIterable {
    case psv // 공무원
    case edu // 교육
    case dev // 개발
    case psm // 기획/전략/경영
    case des // 디자인
    case mpr // 마케팅/PR
    case ser // 서비스
    case pro // 생산
    case res // 연구
    case saf // 영업/제휴
    case med // 의료
    case hur // 인사
    case acc // 재무 회계
    case cus // CS
    case none
}

extension Job {
    var code: String {
        switch self {
        case .psv:
            return "PSV"
        case .edu:
            return "EDU"
        case .dev:
            return "DEV"
        case .psm:
            return "PSM"
        case .des:
            return "DES"
        case .mpr:
            return "MPR"
        case .ser:
            return "SER"
        case .pro:
            return "PRO"
        case .res:
            return "RES"
        case .saf:
            return "SAF"
        case .med:
            return "MED"
        case .hur:
            return "HUR"
        case .acc:
            return "ACC"
        case .cus:
            return "CUS"
        case .none:
            return ""
        }
    }

    init(code: String) {
        for job in Job.allCases {
            if job.code == code {
                self = job
                return
            }
        }
        self = .none
    }

    var name: String {
        switch self {
        case .psv:
            return L10n.Job.psv
        case .edu:
            return L10n.Job.edu
        case .psm:
            return L10n.Job.psm
        case .dev:
            return L10n.Job.dev
        case .mpr:
            return L10n.Job.mpr
        case .des:
            return L10n.Job.des
        case .ser:
            return L10n.Job.ser
        case .pro:
            return L10n.Job.pro
        case .res:
            return L10n.Job.res
        case .saf:
            return L10n.Job.saf
        case .med:
            return L10n.Job.med
        case .hur:
            return L10n.Job.hur
        case .acc:
            return L10n.Job.acc
        case .cus:
            return L10n.Job.cus
        case .none:
            return ""
        }
    }
}
