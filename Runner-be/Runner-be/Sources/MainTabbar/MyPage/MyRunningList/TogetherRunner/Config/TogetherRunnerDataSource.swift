//
//  TogetherRunnerDataSource.swift
//  Runner-be
//
//  Created by 김창규 on 9/3/24.
//

import Foundation
import RxDataSources

struct TogetherRunnerConfig: Equatable, IdentifiableType {
    let userId: Int
    let nickname: String
    let profileImageUrl: String?
    let isOpened: Int?
    let stampCode: String?

    var identity: String {
        "\(userId)"
    }

    init(from: LogPartners) {
        userId = from.userId
        nickname = from.nickname
        profileImageUrl = from.profileImageUrl
        isOpened = from.isOpened
        stampCode = from.stampCode
    }
}

struct TogetherRunnerSection {
    var items: [TogetherRunnerConfig]
    var identity: String

    init(items: [TogetherRunnerConfig]) {
        self.items = items
        identity = items.map { $0.identity }.joined(separator: ",")
    }
}

extension TogetherRunnerSection: AnimatableSectionModelType {
    init(
        original: TogetherRunnerSection,
        items: [TogetherRunnerConfig]
    ) {
        self = original
        self.items = items
    }
}
