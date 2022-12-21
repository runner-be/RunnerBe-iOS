//
//  AlarmListSection.swift
//  Runner-be
//
//  Created by 김신우 on 2022/08/21.
//

import Foundation
import RxDataSources

struct AlarmCellConfig: Equatable, IdentifiableType {
    let id: Int
    let title: String
    let content: String
    let isNew: Bool
    let timeDiff: String

    var identity: String {
        "\(id)"
    }

    init(from alarm: Alarm) {
        id = alarm.alarmID
        title = alarm.title
        content = alarm.content
        isNew = alarm.isNew
        timeDiff = DateUtil.shared.relativeDateString(for: alarm.createdAt, relativeTo: Date())
    }
}

struct AlarmListSection {
    var items: [AlarmCellConfig]
    var identity: String

    init(items: [AlarmCellConfig]) {
        self.items = items
        identity = items.map { $0.identity }.joined(separator: ",")
    }
}

extension AlarmListSection: AnimatableSectionModelType {
    init(original: AlarmListSection, items: [AlarmCellConfig]) {
        self = original
        self.items = items
    }
}
