//
//  PostCellConfig.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/23.
//

import RxDataSources
import UIKit

struct PostCellConfig: Equatable, IdentifiableType {
    let id: Int
    let title: String
    let date: String
    let time: String
    let place: String
    let gender: String
    let ageText: String
    var writerAvr: UIImage?
    let writerName: String
    let writerProfileURL: String?
    var bookmarked: Bool
    let closed: Bool
    var runningTag: String
    let afterParty: Int
    let pace: String
    let attendanceProfiles: [ProfileURL]
    let peopleNum: Int

    var runningState: RunningState
    private let userId = BasicLoginKeyChainService.shared.userId!

    init(from post: Post) {
        id = post.ID
        title = post.title
        date =
            DateUtil.shared.formattedString(for: post.gatherDate, format: .custom(format: "M/d (E)"))
                + " "
                + DateUtil.shared.formattedString(for: post.gatherDate, format: .ampm, localeId: "en_US")
                + " "
                + DateUtil.shared.formattedString(for: post.gatherDate, format: .custom(format: "hh:mm"))
        time = "\(post.runningTime.hour)시간 \(post.runningTime.minute)분"

        place = post.placeName
        switch post.gender {
        case .female, .male:
            gender = post.gender.name + L10n.Additional.Gender.limit
        case .none:
            gender = post.gender.name
        }

        ageText = "\(post.ageRange.min)-\(post.ageRange.max)"
        writerName = post.writerName
        writerProfileURL = post.writerProfileURL
        closed = !post.open
        bookmarked = post.marked
        runningTag = post.tag.code
        afterParty = post.afterParty
        pace = post.pace
        attendanceProfiles = post.attendanceProfiles
        peopleNum = post.peopleNum

        // FIXME: 하드코딩 MyPageConfig에 중복 코드
        let currentIntervalFromRef = Date().timeIntervalSince1970 // 현재 시간
        let startIntervalFromRef = post.gatherDate.timeIntervalSince1970 // 모임 시간
        let runningInterval = TimeInterval(post.runningTime.hour * 60 * 60 + post.runningTime.minute * 60) // 러닝 시간
        let attendanceTimeLimit: Double = (3 * 60 * 60) // 출석관리 가능 시간 TODO: 3시간 고정 재 확인
        let isCreator = post.writerID == userId

        if isCreator { // 모임 작성자
            let isStart = currentIntervalFromRef > startIntervalFromRef // 모임이 시작했는가?
            let isAttendanceClosed = currentIntervalFromRef > startIntervalFromRef + runningInterval + attendanceTimeLimit // 모임 시작 후 출석 마감이 되었는가?

            if isStart { // (작성자) 모임 시작 후
                if isAttendanceClosed {
                    runningState = .attendanceClosed // 모임 종료
                } else {
                    runningState = .creatorDuringMeetingBeforeEnd // 모집 마감
                }
            } else { // (작성자) 모임 시작 전
                if post.peopleNum == post.attendanceProfiles.count {
                    runningState = .creatorDuringMeetingBeforeEnd // 모집 마감
                } else {
                    runningState = .creatorBeforeMeetingStart // 모집중
                }
            }
        } else { // 모임 참여자
            let isDuring = currentIntervalFromRef < startIntervalFromRef + runningInterval
            let isAttendanceClosed = currentIntervalFromRef > startIntervalFromRef + runningInterval + attendanceTimeLimit // 모임 시작 후 출석 마감이 되었는가?

            if isDuring { // 모임 진행 중
                if post.peopleNum == post.attendanceProfiles.count {
                    runningState = .creatorDuringMeetingBeforeEnd // 모집 마감
                } else {
                    runningState = .participantDuringMeeting // 모집중
                }
            } else { // 모임 종료
                if isAttendanceClosed {
                    runningState = .attendanceClosed // 출석 마감
                } else {
                    runningState = .logSubmissionClosed // 모집 종료
                }
            }
        }

        // 모임에 logID가 있으면 로그쓰기 마감입니다.
        if post.logId != nil {
            runningState = .logSubmissionClosed
        }
    }

    init(from post: Post, marked: Bool) {
        self.init(from: post)
        bookmarked = marked
    }

    var identity: String {
        "\(id)"
    }

    static func == (lhs: PostCellConfig, rhs: PostCellConfig) -> Bool {
        lhs.id == rhs.id && lhs.bookmarked == rhs.bookmarked
    }
}
