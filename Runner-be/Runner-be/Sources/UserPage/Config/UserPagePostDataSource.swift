//
//  UserPagePostDataSource.swift
//  Runner-be
//
//  Created by 김창규 on 10/22/24.
//

import Foundation
import RxDataSources

struct UserPagePostSection {
    var items: [UserPagePostConfig]
    var identity: String

    init(items: [UserPagePostConfig]) {
        self.items = items
        identity = items.map { $0.identity }.joined(separator: ",")
    }
}

extension UserPagePostSection: AnimatableSectionModelType {
    typealias Item = UserPagePostConfig

    init(original: UserPagePostSection, items: [Item]) {
        self = original
        self.items = items
    }
}
