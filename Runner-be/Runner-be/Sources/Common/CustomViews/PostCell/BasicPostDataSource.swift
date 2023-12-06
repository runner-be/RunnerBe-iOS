//
//  BasicPostDataSource.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/24.
//

import Foundation
import RxDataSources

struct BasicPostSection {
    var items: [PostCellConfig]
    var identity: String

    init(items: [PostCellConfig]) {
        self.items = items
        identity = items.map { $0.identity }.joined(separator: ",")
    }
}

extension BasicPostSection: AnimatableSectionModelType {
    typealias Item = PostCellConfig

    init(original: BasicPostSection, items: [Item]) {
        self = original
        self.items = items
    }
}
