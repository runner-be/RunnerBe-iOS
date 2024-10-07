//
//  LogStampDataSource.swift
//  Runner-be
//
//  Created by 김창규 on 9/1/24.
//

import Foundation
import RxDataSources

struct LogStampConfig: Equatable, IdentifiableType {
    let id = UUID()
    let stampType: StampType?
    let isEnabled: Bool

    var identity: String {
        "\(id)"
    }

    init(
        from: StampType?,
        isEnabled: Bool = true
    ) {
        stampType = from
        self.isEnabled = isEnabled
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
