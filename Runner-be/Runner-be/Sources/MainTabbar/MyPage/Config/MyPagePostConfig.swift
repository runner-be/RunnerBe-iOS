//
//  PostCellConfig.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import Foundation
import RxDataSources

enum PostAttendState {
    // 작성한 글 탭
    case beforeManagable
    case managable
    case afterManage
    // 참여 러닝 탭
    case beforeManage
    case attendance
    case absence
    case notManage
}

struct MyPagePostConfig: Equatable, IdentifiableType {
    let cellConfig: PostCellConfig
    let state: PostAttendState

    init(post: Post, now: Date) {
        cellConfig = PostCellConfig(from: post)

        let currentIntervalFromRef = now.timeIntervalSince1970
        let startIntervalFromRef = post.gatherDate.timeIntervalSince1970
        let runningInterval = TimeInterval(post.runningTime.hour * 60 * 60 + post.runningTime.minute)

        if post.writerID != post.writerID, currentIntervalFromRef < startIntervalFromRef { // 시작안했음
            state = .beforeManagable
        } else if post.writerID != post.writerID, currentIntervalFromRef < startIntervalFromRef + runningInterval + (3 * 60 * 60) { // 시작 ~ 3시간 전
            state = .managable
        } else if post.writerID != post.writerID, currentIntervalFromRef > startIntervalFromRef + runningInterval + (3 * 60 * 60) { // 시작 후 3시간 후
            state = .afterManage
            // 위 까지가 '작성한 글' 시점
        } else if post.writerID == post.writerID, post.whetherCheck == "N" { // 리더의 출석을 기다리는중
            state = .beforeManage
        } else if post.writerID == post.writerID, post.whetherCheck == "Y", post.attendance == true { // 참석
            state = .attendance
        } else if post.writerID == post.writerID, post.whetherCheck == "Y", post.attendance == false { // 불참
            state = .absence
        } else {
            state = .notManage
        }
    }

    var identity: String {
        "\(cellConfig.id)"
    }
}
