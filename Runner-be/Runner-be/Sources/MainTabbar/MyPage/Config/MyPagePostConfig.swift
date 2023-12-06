//
//  MyPagePostConfig.swift
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
    private let userId = BasicLoginKeyChainService.shared.userId!

    init(post: Post, now: Date) {
        cellConfig = PostCellConfig(from: post)
        myRunningState = .beforeManagable
        myParticipateState = .memberbeforeManage

        let currentIntervalFromRef = now.timeIntervalSince1970 // 현재 시간
        let startIntervalFromRef = post.gatherDate.timeIntervalSince1970 // 모임 시간
        let runningInterval = TimeInterval(post.runningTime.hour * 60 * 60 + post.runningTime.minute * 60) // 러닝 시간

        // 참여 러닝
        if currentIntervalFromRef < startIntervalFromRef + runningInterval + (3 * 60 * 60) { // 출석 관리 시간이 아직 지나지 않음
            if post.writerID != userId { // 참여자 : 리더의 체크를 기다리고 있어요
                myParticipateState = .memberbeforeManage
            } else {
                myParticipateState = .writerbeforeManage // 리더 : 참여자의 출석을 체크해주세요
                if startIntervalFromRef < currentIntervalFromRef { // 작성한글 / 출석 관리
                    myRunningState = .managable
                }
            }
        } else if currentIntervalFromRef > startIntervalFromRef + runningInterval + (3 * 60 * 60) {
            if post.writerID != userId {
                if post.whetherCheck == "N" { // 참여자 : 종료 이후에도 리더가 출석 체크 안했을 때
                    myParticipateState = .membernotManage
                }
            } else { // 리더
                myRunningState = .confirmManage // 출석 확인하기
                if post.whetherCheck == "N" { // 리더 : 종료 이후에도 출석 체크 안했을 때
                    myParticipateState = .writernotManage
                }
            }

            if post.whetherCheck == "Y" {
                if post.attendance {
                    myParticipateState = .attendance
                } else {
                    myParticipateState = .absence
                }
            }

        } else if post.writerID == userId, currentIntervalFromRef < startIntervalFromRef { // 러닝후에 관리해주세요 (리더인데 시작 전)
            myRunningState = .beforeManagable
        }
    }

    var identity: String {
        "\(cellConfig.id)"
    }
}
