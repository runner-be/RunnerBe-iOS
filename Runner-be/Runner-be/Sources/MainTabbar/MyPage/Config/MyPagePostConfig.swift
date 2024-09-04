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

// [러닝모임 진행순서]
// 1. 모임 작성(관리자) or 모임 참여(참여자)
// 2. 모임 시작 전
// 3. (모임에 설정된 시간에) 모임 시작
// 4. 출석 시작
// 5. 모임 시작
// 6. 모임 중
// 7. ( 소요시간 뒤 ) 모임 종료
// 8. ( 4번 시점부터 3시간 동안 ) 출석 진행 중
// 9. 출석 마감
// 10. (로그작성 시) 로그 마감
// 11. 종료

enum RunningState {
    case participantDuringMeeting // 참여자 모임참여(1) ~ 모임 중(6)
    case creatorBeforeMeetingStart // 작성자 모임작성(1) ~ 모임 시작 전(2)
    case creatorDuringMeetingBeforeEnd // 작성자 모임시작(3) ~ 출석 진행(8)
    case attendanceClosed // 출석 마감(9)
    case logSubmissionClosed // 로그 마감(10)
}

struct MyPagePostConfig: Equatable, IdentifiableType {
    let cellConfig: PostCellConfig
    var runningState: RunningState
    private let userId = BasicLoginKeyChainService.shared.userId!

    init(post: Post, now: Date) {
        cellConfig = PostCellConfig(from: post)
        let currentIntervalFromRef = now.timeIntervalSince1970 // 현재 시간
        let startIntervalFromRef = post.gatherDate.timeIntervalSince1970 // 모임 시간
        let runningInterval = TimeInterval(post.runningTime.hour * 60 * 60 + post.runningTime.minute * 60) // 러닝 시간
        let attendanceTimeLimit: Double = (3 * 60 * 60)
        let isCreator = post.writerID == userId

        if isCreator { // 모임 작성자
            let isStart = currentIntervalFromRef > startIntervalFromRef // 모임이 시작했는가?
            let isAttendanceClosed = currentIntervalFromRef > startIntervalFromRef + runningInterval + attendanceTimeLimit // 모임 시작 후 출석 마감이 되었는가?

            if isStart { // (작성자) 모임 시작 후
                if isAttendanceClosed {
                    runningState = .attendanceClosed
                } else {
                    runningState = .creatorDuringMeetingBeforeEnd
                }
            } else { // (작성자) 모임 시작 전
                runningState = .creatorBeforeMeetingStart
            }
        } else { // 모임 참여자
            let isDuring = currentIntervalFromRef < startIntervalFromRef + runningInterval
            let isAttendanceClosed = currentIntervalFromRef > startIntervalFromRef + runningInterval + attendanceTimeLimit // 모임 시작 후 출석 마감이 되었는가?

            if isDuring { // 모임 진행 중
                runningState = .participantDuringMeeting
            } else { // 모임 종료
                if isAttendanceClosed {
                    runningState = .attendanceClosed
                } else {
                    runningState = .logSubmissionClosed
                }
            }
        }
    }

    var identity: String {
        "\(cellConfig.id)"
    }
}
