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
    case error
}

struct MyPagePostConfig: Equatable, IdentifiableType {
    let cellConfig: PostCellConfig
    let state: PostAttendState

    init(post: Post, dateService: DateService) {
        cellConfig = PostCellConfig(from: post)

        if post.attendance {
            state = .attend
        } else {
            let currentTime = dateService.currentTimeObject
            if let runningTime = dateService.getTimeObject(string: post.runningTime, format: .running),
               let startTime = dateService.getTimeObject(string: post.gatheringTime, format: .gathering)
            {
                let currentIntervalFromRef = currentTime.date.timeIntervalSince1970
                let startIntervalFromRef = startTime.date.timeIntervalSince1970
                let runningInterval = TimeInterval(runningTime.hour * 60 * 60 + runningTime.minute * 60)

                if currentIntervalFromRef < startIntervalFromRef {
                    state = .beforeAttendable
                } else if currentIntervalFromRef < startIntervalFromRef + runningInterval + (3 * 60 * 60) {
                    state = .attendable
                } else {
                    state = .absence
                }
            } else {
                state = .error
            }
        }
    }

    var identity: String {
        "\(cellConfig.id)"
    }
}
