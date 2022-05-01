//
//  MyPagePostDataSource.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import Foundation
import RxDataSources

struct MyPagePostSection {
    var items: [MyPagePostConfig]
    var identity: String

    init(items: [MyPagePostConfig]) {
        self.items = items
        identity = items.map { $0.identity }.joined(separator: ",")
    }
}

extension MyPagePostSection: AnimatableSectionModelType {
    typealias Item = MyPagePostConfig

    init(original: MyPagePostSection, items: [Item]) {
        self = original
        self.items = items
    }
}
