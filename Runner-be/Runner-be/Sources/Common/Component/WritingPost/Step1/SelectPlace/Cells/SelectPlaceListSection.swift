//
//  SelectPlaceListSection.swift
//  Runner-be
//
//  Created by 김창규 on 8/22/24.
//

import Foundation
import RxDataSources

struct SelectPlaceResultCellConfig: Equatable, IdentifiableType {
    let id = UUID()
    let title: String
    let subTitle: String

    var identity: String {
        "\(id)"
    }

    init(from: PlaceInfo) {
        title = from.title
        subTitle = from.subTitle
    }
}

struct SelectPlaceListSection {
    var items: [SelectPlaceResultCellConfig]
    var identity: String

    init(items: [SelectPlaceResultCellConfig]) {
        self.items = items
        identity = items.map { $0.identity }.joined(separator: ",")
    }
}

extension SelectPlaceListSection: AnimatableSectionModelType {
    init(
        original: SelectPlaceListSection,
        items: [SelectPlaceResultCellConfig]
    ) {
        self = original
        self.items = items
    }
}
