//
//  MyPageParticipatePostDataSource.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/02.
//

import Foundation
import RxDataSources

struct MyPageParticipateSection {
    var items: [MyPageParticipatePostConfig]
    var identity: String

    init(items: [MyPageParticipatePostConfig]) {
        self.items = items
        identity = items.map { $0.identity }.joined(separator: ",")
    }
}

extension MyPageParticipateSection: AnimatableSectionModelType {
    typealias Item = MyPageParticipatePostConfig

    init(original: MyPageParticipateSection, items: [Item]) {
        self = original
        self.items = items
    }
}
