//
//  PostCellConfig.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import Foundation
import RxDataSources

enum PostAttendState {
    case beforeManagable
    case managable
    case afterManage
}

struct MyPagePostConfig: Equatable, IdentifiableType {
    let cellConfig: PostCellConfig
    let state: PostAttendState

    init(post: Post, now: Date) {
        cellConfig = PostCellConfig(from: post)

        let currentIntervalFromRef = now.timeIntervalSince1970
        let startIntervalFromRef = post.gatherDate.timeIntervalSince1970
        let runningInterval = TimeInterval(post.runningTime.hour * 60 * 60 + post.runningTime.minute)

        if currentIntervalFromRef < startIntervalFromRef { // 시작안했음
            state = .beforeManagable
        } else if currentIntervalFromRef < startIntervalFromRef + runningInterval + (3 * 60 * 60) { // 시작 ~ 3시간 전
            state = .managable
        } else { // 3시간 뒤
            state = .afterManage
        }
    }

    var identity: String {
        "\(cellConfig.id)"
    }
}
