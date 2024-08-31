//
//  ReceivedStampDataSource.swift
//  Runner-be
//
//  Created by 김창규 on 9/1/24.
//

import Foundation
import RxDataSources

struct ReceivedStamp {
    var userName: String
    var userProfileURL: String
    var stampStatus: RunningLogStatus
}

struct ReceivedStampConfig: Equatable, IdentifiableType {
    let id = UUID() // FIXME: userid로 변경
    var userName: String
    var userProfileURL: String
    var stampStatus: RunningLogStatus

    var identity: String {
        "\(id)"
    }

    init(from: ReceivedStamp) {
        userName = from.userName
        userProfileURL = from.userProfileURL
        stampStatus = from.stampStatus
    }
}

struct ReceivedStampSection {
    var items: [ReceivedStampConfig]
    var identity: String

    init(items: [ReceivedStampConfig]) {
        self.items = items
        identity = items.map { $0.identity }.joined(separator: ",")
    }
}

extension ReceivedStampSection: AnimatableSectionModelType {
    init(
        original: ReceivedStampSection,
        items: [ReceivedStampConfig]
    ) {
        self = original
        self.items = items
    }
}
