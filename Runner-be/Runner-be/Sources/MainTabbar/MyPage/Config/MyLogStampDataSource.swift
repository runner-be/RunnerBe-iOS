//
//  MyLogStampDataSource.swift
//  Runner-be
//
//  Created by 김창규 on 8/27/24.
//

import Foundation
import RxDataSources

struct LogStamp {
    var dayOfWeek: String
    var date: Int
    var isToday: Bool
}

struct MyLogStampConfig: Equatable, IdentifiableType {
    let id = UUID()
    let dayOfWeek: String
    let date: Int
    var isToday: Bool

    var identity: String {
        "\(id)"
    }

    init(from: LogStamp) {
        date = from.date
        dayOfWeek = from.dayOfWeek
        isToday = from.isToday
    }
}

struct MyLogStampSection {
    var items: [MyLogStampConfig]
    var identity: String

    init(items: [MyLogStampConfig]) {
        self.items = items
        identity = items.map { $0.identity }.joined(separator: ",")
    }
}

extension MyLogStampSection: AnimatableSectionModelType {
    init(
        original: MyLogStampSection,
        items: [MyLogStampConfig]
    ) {
        self = original
        self.items = items
    }
}
