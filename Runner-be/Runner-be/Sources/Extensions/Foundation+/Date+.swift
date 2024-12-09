//
//  Date+.swift
//  Runner-be
//
//  Created by 김창규 on 8/28/24.
//

import Foundation

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
    }

    func with(day: Int) -> Date? {
        var components = Calendar.current.dateComponents([.year, .month], from: self)
        components.day = day
        return Calendar.current.date(from: components)
    }
}
