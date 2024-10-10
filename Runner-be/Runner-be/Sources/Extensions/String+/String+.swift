//
//  String+.swift
//  Runner-be
//
//  Created by 김창규 on 10/10/24.
//

import Foundation

extension String {
    func toDate(
        withFormat format: String = "yyyy-MM-dd HH:mm:ss Z",
        timeZoneIdentifier: String = "Asia/Seoul"
    ) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: timeZoneIdentifier)
        return dateFormatter.date(from: self)
    }
}
