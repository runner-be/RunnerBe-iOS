//
//  WritingPostConfig.swift
//  Runner-be
//
//  Created by 김신우 on 2022/09/03.
//

import CoreLocation
import Foundation

struct WritingPostData {
    // Step1
    var tag: String = RunningTag.beforeWork.name
    var title: String = ""
    var date: TimeInterval = Date().timeIntervalSince1970
    var dateString: String {
        let date = Date(timeIntervalSince1970: date)

        return DateUtil.shared.formattedString(for: date, format: .custom(format: "M/d (E)"))
            + " "
            + DateUtil.shared.formattedString(for: date, format: .ampm, localeId: "en_US")
            + " "
            + DateUtil.shared.formattedString(for: date, format: .custom(format: "hh:mm"))
    }

    var time: String = "1시간 00분"
    var location: CLLocationCoordinate2D
    var placeInfo: String = ""

    // Step2
    var gender: Int = Gender.none.index
    var ageMin: Int = 20
    var ageMax: Int = 65
    var numPerson: Int = 2
    var content: String = ""
}
