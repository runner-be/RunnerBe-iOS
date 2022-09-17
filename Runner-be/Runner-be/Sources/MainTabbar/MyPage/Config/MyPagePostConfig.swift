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
        let runningInterval = TimeInterval(post.runningTime.hour * 60 * 60 + post.runningTime.minute * 60)

        if post.writerID != UserInfo().userId, post.whetherCheck == "N", currentIntervalFromRef < startIntervalFromRef + runningInterval + (3 * 60 * 60) { // 출석체크X & 3시간 전 -> 리더의 체크를 기다리고있어요
            state = .beforeManage
        } else if post.writerID != UserInfo().userId, post.whetherCheck == "Y", post.attendance == true { // 출석
            state = .attendance
        } else if post.writerID != UserInfo().userId, post.whetherCheck == "Y", post.attendance == false { // 결석
            state = .absence
            // 위 까지가 '참여 러닝' 시점
        } else if post.writerID == UserInfo().userId, post.whetherCheck == "N", currentIntervalFromRef < startIntervalFromRef { // 러닝 후에 출석을 관리해주세요 -> 시작 전까지
            state = .beforeManagable
        } else if post.writerID == UserInfo().userId, currentIntervalFromRef < startIntervalFromRef + runningInterval + (3 * 60 * 60) { // 출석 관리 -> 시작 전 ~ 종료 + 3시간 전까지
            state = .managable
        } else if post.writerID == UserInfo().userId, currentIntervalFromRef > startIntervalFromRef + runningInterval + (3 * 60 * 60) { // 출석 확인하기
            state = .afterManage
        } else {
            state = .notManage // 리더가 출석을 체크하지 않았어요
        }
    }

    var identity: String {
        "\(cellConfig.id)"
    }
}
