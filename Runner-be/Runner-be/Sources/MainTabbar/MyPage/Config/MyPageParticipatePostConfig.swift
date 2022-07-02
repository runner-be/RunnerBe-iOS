//
//  MyPageParticipatePostConfig.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/02.
//

import Foundation
import RxDataSources

enum ParticipateAttendState {
    case beforeManage
    case attendance
    case absence
}

struct MyPageParticipatePostConfig: Equatable, IdentifiableType {
    let cellConfig: PostCellConfig
//    let state: ParticipateAttendState

    init(post: Post, now _: Date) {
        cellConfig = PostCellConfig(from: post)

//        let currentIntervalFromRef = now.timeIntervalSince1970
//        let startIntervalFromRef = post.gatherDate.timeIntervalSince1970
//        let runningInterval = TimeInterval(post.runningTime.hour * 60 * 60 + post.runningTime.minute)
//
//        if currentIntervalFromRef < startIntervalFromRef { // 시작안했음
//            state = .beforeManagable
//        } else if currentIntervalFromRef < startIntervalFromRef + runningInterval + (3 * 60 * 60) {
//            state = .managable
//        } else {
//            state = .afterManage
//        }
    }

    var identity: String {
        "\(cellConfig.id)"
    }
}
