//
//  MyPostResElement.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/01.
//

import Foundation

// MARK: - MyPostResElement

struct MyPostResElement: Codable {
    let postID: Int
    let postUserID: Int
    let nickName: String
    let profileImageURL: String?
    let title: String
    let runningTime: String
    let gatheringTime: String
    let locationInfo: String
    let runningTag: String
    let age: String
    let gender: String
    let whetherEnd: String
    let job: String

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case postUserID = "postUserId"
        case nickName
        case profileImageURL = "profileImageUrl"
        case title
        case runningTime
        case gatheringTime
        case locationInfo
        case runningTag
        case age
        case gender
        case whetherEnd
        case job
    }
}

extension MyPostResElement {
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
        return formatter.date(from: gatheringTime)
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

        post.marked = false
        post.attendance = false
        post.open = open

        return post
    }
}
