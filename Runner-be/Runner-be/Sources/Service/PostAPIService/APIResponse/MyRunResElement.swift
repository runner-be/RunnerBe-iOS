//
//  MyRunResElement.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/01.
//

import Foundation

// MARK: - MyRunResElement

struct MyRunResElement: Codable {
    let whetherEnd: String
    let runningTag: String
    let gender: String
    let job: String
    let postID: Int
    let gatheringTime: String
    let nickName: String
    let profileImageURL: String?
    let runningTime: String
    let postUserID: Int
    let locationInfo: String
    let title: String
    let bookMark: Int
    let attendance: Int
    let age: String

    enum CodingKeys: String, CodingKey {
        case whetherEnd
        case runningTag
        case gender
        case job
        case postID = "postId"
        case gatheringTime
        case nickName
        case profileImageURL = "profileImageUrl"
        case runningTime
        case postUserID = "postUserId"
        case locationInfo
        case title
        case bookMark
        case attendance
        case age
    }
}

extension MyRunResElement {
    var jobTypes: [Job] {
        return job.components(separatedBy: ",").reduce(into: [Job]()) {
            let jType = Job(code: $1)
            if jType == .none { return }
            $0.append(jType)
        }
    }

    var ageRange: (min: Int, max: Int)? {
        let components = age.components(separatedBy: "-")
        guard components.count >= 2,
              let min = Int(components[0]),
              let max = Int(components[1])
        else { return nil }
        return (min: min, max: max)
    }

    var gatherDate: Date? { // "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let formatter = DateUtil.shared.dateFormatter
        formatter.dateFormat = DateFormat.apiDate.formatString
        var date = formatter.date(from: gatheringTime)
        date = date?.addingTimeInterval(TimeInterval(-TimeZone.current.secondsFromGMT()))
        return date
    }

    var timeRunning: (hour: Int, minute: Int)? {
        let hms = runningTime.components(separatedBy: ":") // hour miniute seconds
        guard hms.count > 2,
              let hour = Int(hms[0]),
              let minute = Int(hms[1])
        else { return nil }
        return (hour: hour, minute: minute)
    }

    var genderType: Gender {
        return Gender(name: gender)
    }

    var runningTagType: RunningTag {
        return RunningTag(code: runningTag)
    }

    var open: Bool {
        return whetherEnd == "N"
    }

    var marked: Bool {
        return bookMark == 1
    }

    var attends: Bool {
        return attendance == 1
    }

    var convertedPost: Post? {
        guard let runningTime = timeRunning,
              let gatherDate = gatherDate,
              let ageRange = ageRange
        else { return nil }

        let id = postID
        let writerID = postUserID
        let writerName = nickName
        let writerProfileURL = profileImageURL
        let title = title
        let tag = runningTagType
        let locationInfo = locationInfo
        // coords : nil

        var post = Post(
            ID: id,
            writerID: writerID,
            writerName: writerName,
            writerProfileURL: writerProfileURL,
            title: title,
            tag: tag,
            runningTime: runningTime,
            gatherDate: gatherDate,
            ageRange: ageRange,
            gender: genderType,
            locationInfo: locationInfo,
            coord: nil
        )

        post.marked = marked
        post.attendance = attends
        post.open = open && post.gatherDate > Date()

        return post
    }
}
