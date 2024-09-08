//
//  MyLogStampDataSource.swift
//  Runner-be
//
//  Created by 김창규 on 8/27/24.
//

import Foundation
import RxDataSources

struct LogStamp {
    let date: Date
    let stampType: StampType?
}

struct MyLogStampConfig: Equatable, IdentifiableType {
    let id = UUID()
    var date: Date
    var stampType: StampType?

    var identity: String {
        "\(id)"
    }

    init(from: LogStamp) {
        date = from.date
        stampType = from.stampType
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
