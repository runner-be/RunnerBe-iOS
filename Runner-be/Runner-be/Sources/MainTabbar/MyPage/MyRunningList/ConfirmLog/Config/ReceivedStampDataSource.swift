//
//  ReceivedStampDataSource.swift
//  Runner-be
//
//  Created by 김창규 on 9/1/24.
//

import Foundation
import RxDataSources

struct GotStampConfig: Equatable, IdentifiableType {
    let id = UUID() // FIXME: userid로 변경
    let userId: Int
    let logId: Int?
    let nickname: String
    let profileImageUrl: String?
    let stampCode: String

    var identity: String {
        "\(userId)"
    }

    init(from: GotStamp) {
        userId = from.userId
        logId = from.logId
        nickname = from.nickname
        profileImageUrl = from.profileImageUrl
        stampCode = from.stampCode
    }
}

struct ReceivedStampSection {
    var items: [GotStampConfig]
    var identity: String

    init(items: [GotStampConfig]) {
        self.items = items
        identity = items.map { $0.identity }.joined(separator: ",")
    }
}

extension ReceivedStampSection: AnimatableSectionModelType {
    init(
        original: ReceivedStampSection,
        items: [GotStampConfig]
    ) {
        self = original
        self.items = items
    }
}
