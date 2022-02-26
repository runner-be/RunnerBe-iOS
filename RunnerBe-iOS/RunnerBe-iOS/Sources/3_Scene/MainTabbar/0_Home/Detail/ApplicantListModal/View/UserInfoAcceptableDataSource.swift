//
//  UserInfoAcceptableDataSource.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/26.
//

import Foundation
import RxDataSources

struct UserInfoAcceaptableSection {
    var items: [PostDetailUserConfig]
    var identity: String

    init(items: [PostDetailUserConfig]) {
        self.items = items
        identity = UUID().uuidString
    }
}

extension UserInfoAcceaptableSection: AnimatableSectionModelType {
    typealias Item = PostDetailUserConfig

    init(original: UserInfoAcceaptableSection, items: [Item]) {
        self = original
        self.items = items
    }
}
