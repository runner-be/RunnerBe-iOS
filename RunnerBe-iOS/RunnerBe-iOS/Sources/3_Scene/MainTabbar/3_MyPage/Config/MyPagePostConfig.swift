//
//  PostCellConfig.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import Foundation
import RxDataSources

enum PostAttendState {
    case beforeAttendable
    case attendable
    case attend
    case absence
}

struct MyPagePostConfig: Equatable, IdentifiableType {
    let cellConfig: PostCellConfig
    let state: PostAttendState

    init(post: Post, now: Date) {
        cellConfig = PostCellConfig(from: post)

        if post.attendance {
            state = .attend
        } else {
            let currentIntervalFromRef = now.timeIntervalSince1970
            let startIntervalFromRef = post.gatherDate.timeIntervalSince1970
            let runningInterval = TimeInterval(post.runningTime.hour * 60 * 60 + post.runningTime.minute)

            if currentIntervalFromRef < startIntervalFromRef {
                state = .beforeAttendable
            } else if currentIntervalFromRef < startIntervalFromRef + runningInterval + (3 * 60 * 60) {
                state = .attendable
            } else {
                state = .absence
            }
        }
    }

    var identity: String {
        "\(cellConfig.id)"
    }
}
