//
//  UserPagePostConfig.swift
//  Runner-be
//
//  Created by 김창규 on 10/22/24.
//

import Foundation
import RxDataSources

struct UserPagePostConfig: Equatable, IdentifiableType {
    let cellConfig: UserPostCellConfig
    var runningState: RunningState
    var identity: String {
        "\(cellConfig.id)"
    }

    init(
        userPost: UserPost
    ) {
        cellConfig = UserPostCellConfig(from: userPost)
        let now = Date()
        let currentIntervalFromRef = now.timeIntervalSince1970 // 현재 시간
        let startIntervalFromRef = userPost.gatherDate.timeIntervalSince1970 // 모임 시간
        let runningHour = userPost.runningTime.hour * 60 * 60
        let runningMin = userPost.runningTime.minute * 60
        let runningInterval = TimeInterval(runningHour + runningMin) // 러닝 시간
        let attendanceTimeLimit: Double = (3 * 60 * 60)

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

        // 모임에 logID가 있으면 로그쓰기 마감입니다.
        if userPost.logId != nil {
            runningState = .logSubmissionClosed
        }
    }
}

struct UserPostCellConfig: Equatable, IdentifiableType {
    let id: Int
    let title: String
    let gender: String
    let age: String
    let afterParty: Int
    let pace: String
    let date: String
    var identity: String {
        "\(id)"
    }

    init(from userPost: UserPost) {
        id = userPost.postId
        title = userPost.title
        gender = userPost.gender
        age = userPost.age
        afterParty = userPost.afterParty
        pace = userPost.pace
        date =
            DateUtil.shared.formattedString(for: userPost.gatherDate, format: .custom(format: "M/d (E)"))
                + " "
                + DateUtil.shared.formattedString(for: userPost.gatherDate, format: .ampm, localeId: "en_US")
                + " "
                + DateUtil.shared.formattedString(for: userPost.gatherDate, format: .custom(format: "hh:mm"))
    }
}
