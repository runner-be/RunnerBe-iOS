//
//  PostCellConfig.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import Foundation
import RxDataSources

enum MyRunningState {
    // 작성한 글 탭 (작성자)
    case beforeManagable // 러닝 후에 출석을 관리해주세요
    case managable // 출석 관리하기
    case confirmManage // 출석 확인하기
}

enum MyParticipateState {
    // 참여 러닝 탭 (작성자 + 참여자)
    case memberbeforeManage // 리더의 체크를 기다리고 있어요
    case writerbeforeManage // 모임 후 출석을 체크해주세요 (작성자)
    case attendance // 출석
    case absence // 결석
    case membernotManage // 리더가 출석을 체크하지 않았어요
    case writernotManage // 출석을 체크하지 않았어요 (작성자)
}

struct MyPagePostConfig: Equatable, IdentifiableType {
    let cellConfig: PostCellConfig
    var myRunningState: MyRunningState
    var myParticipateState: MyParticipateState

    init(post: Post, now: Date) {
        cellConfig = PostCellConfig(from: post)
        myRunningState = .beforeManagable
        myParticipateState = .memberbeforeManage

        let currentIntervalFromRef = now.timeIntervalSince1970 // 현재 시간
        let startIntervalFromRef = post.gatherDate.timeIntervalSince1970 // 모임 시간
        let runningInterval = TimeInterval(post.runningTime.hour * 60 * 60 + post.runningTime.minute * 60) // 러닝 시간

        // 참여 러닝
        if post.writerID != UserInfo().userId, currentIntervalFromRef < startIntervalFromRef + runningInterval + (3 * 60 * 60) { // 참여자 : 리더의 체크를 기다리고 있어요
            myParticipateState = .memberbeforeManage
        } else if post.writerID == UserInfo().userId, currentIntervalFromRef < startIntervalFromRef + runningInterval + (3 * 60 * 60) { // 시작 이후 -> 출석 관리 가능
            myParticipateState = .writerbeforeManage // 모임전에 체크해주세요
            if startIntervalFromRef < currentIntervalFromRef { // 시작 -> 출석 관리
                myRunningState = .managable
            }
        } else if post.whetherCheck == "Y", post.attendance == true { // 참여자+리더 : 출석
            myParticipateState = .attendance
        } else if post.whetherCheck == "Y", post.attendance == false { // 참여자+리더 : 결석
            myParticipateState = .absence
        } else if post.writerID != UserInfo().userId, post.whetherCheck == "N", currentIntervalFromRef > startIntervalFromRef + runningInterval + (3 * 60 * 60) {
            myParticipateState = .membernotManage
            // 참여자 : 종료 이후에도 리더가 출석 체크 안했을 때
        } else if post.writerID == UserInfo().userId, currentIntervalFromRef > startIntervalFromRef + runningInterval + (3 * 60 * 60) {
            myRunningState = .confirmManage // 출석 확인하기
            if post.whetherCheck == "N" {
                myParticipateState = .writernotManage // 출석을 체크하지 않았어요
            }
        } else if post.writerID == UserInfo().userId, currentIntervalFromRef < startIntervalFromRef { // 러닝후에 관리해주세요 (리더인데 시작 전)
            myRunningState = .beforeManagable
        }
    }

    var identity: String {
        "\(cellConfig.id)"
    }
}
