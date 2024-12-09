//
//  MyLogStampDataSource.swift
//  Runner-be
//
//  Created by 김창규 on 8/27/24.
//

import Foundation
import RxDataSources

struct LogStamp {
    let logId: Int?
    let gatheringId: Int?
    let date: Date
    let stampType: StampType?
    let isOpened: Int?
    let isGathering: Bool
}

struct MyLogStampConfig: Equatable, IdentifiableType {
    let id: String
    let logId: Int?
    let gatheringId: Int?
    var date: Date
    var stampType: StampType?
    let isOpened: Int?
    let isGathering: Bool

    var identity: String {
        id
    }

    init(from: LogStamp) {
        id = from.date.toString()
        logId = from.logId
        gatheringId = from.gatheringId
        date = from.date
        stampType = from.stampType
        isOpened = from.isOpened
        isGathering = from.isGathering
    }

    static func == (lhs: MyLogStampConfig, rhs: MyLogStampConfig) -> Bool {
        return lhs.identity == rhs.identity &&
            lhs.date == rhs.date &&
            lhs.stampType == rhs.stampType &&
            lhs.isGathering == rhs.isGathering &&
            lhs.logId == rhs.logId &&
            lhs.gatheringId == rhs.gatheringId &&
            lhs.isOpened == rhs.isOpened
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
