//
//  TogetherRunnerDataSource.swift
//  Runner-be
//
//  Created by 김창규 on 9/3/24.
//

import Foundation
import RxDataSources

struct TogetherRunner: Equatable {
    let usetProfileURL: String
    let userNickname: String
    var stamp: StampType?
}

struct TogetherRunnerConfig: Equatable, IdentifiableType {
    let id = UUID()
    let usetProfileURL: String
    let userNickname: String
    let stamp: StampType?

    var identity: String {
        "\(id)"
    }

    init(from togetherRunner: TogetherRunner) {
        usetProfileURL = togetherRunner.usetProfileURL
        userNickname = togetherRunner.userNickname
        stamp = togetherRunner.stamp
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
