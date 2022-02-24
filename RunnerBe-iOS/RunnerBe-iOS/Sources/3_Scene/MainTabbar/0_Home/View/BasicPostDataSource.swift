//
//  BasicPostCellDataSource.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/24.
//

import Foundation
import RxDataSources

struct BasicPostSection {
    var items: [PostCellConfiguringItem]
    var uuid = UUID().uuidString

    init(items: [PostCellConfiguringItem]) {
        self.items = items
    }
}

extension BasicPostSection: SectionModelType {
    init(original: BasicPostSection, items: [PostCellConfiguringItem]) {
        self = original
        self.items = items
    }
}

extension BasicPostSection: Equatable {
    static func == (lhs: BasicPostSection, rhs: BasicPostSection) -> Bool {
        lhs.items == rhs.items
    }
}
