//
//  BasicPostCellDataSource.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/24.
//

import Foundation
import RxDataSources

struct BasicPostSection {
    var items: [PostCellConfig]
    var uuid = UUID().uuidString

    init(items: [PostCellConfig]) {
        self.items = items
    }
}

extension BasicPostSection: SectionModelType {
    init(original: BasicPostSection, items: [PostCellConfig]) {
        self = original
        self.items = items
    }
}

extension BasicPostSection: Equatable {
    static func == (lhs: BasicPostSection, rhs: BasicPostSection) -> Bool {
        lhs.items == rhs.items
    }
}
