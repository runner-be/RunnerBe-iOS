//
//  LogStampDataSource.swift
//  Runner-be
//
//  Created by 김창규 on 9/1/24.
//

import Foundation
import RxDataSources

struct LogStamp2: Equatable {
    let stampType: Int
    let stampCode: String
    let stampName: String
    var status: StampType? {
        StampType(rawValue: stampCode)
    }
}

struct LogStampConfig: Equatable, IdentifiableType {
    let id = UUID()
    let stampType: Int
    let stampCode: String
    let stampName: String

    var identity: String {
        "\(id)"
    }

    init(from: LogStamp2) {
        stampType = from.stampType
        stampCode = from.stampCode
        stampName = from.stampName
    }
}

struct LogStampSection {
    var items: [LogStampConfig]
    var identity: String

    init(items: [LogStampConfig]) {
        self.items = items
        identity = items.map { $0.identity }.joined(separator: ",")
    }
}

extension LogStampSection: AnimatableSectionModelType {
    init(
        original: LogStampSection,
        items: [LogStampConfig]
    ) {
        self = original
        self.items = items
    }
}
