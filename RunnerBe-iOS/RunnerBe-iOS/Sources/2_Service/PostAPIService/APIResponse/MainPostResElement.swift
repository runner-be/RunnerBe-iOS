//
//  MainPostResElement.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/01.
//

import Foundation

// MARK: - MainPostResElement

struct MainPostResElement: Codable {
    let locationInfo: String
    let postUserID: Int
    let gender: String
    let runningTag: String
    let job: String
    let gatherLatitude: String
    let distance: String
    let whetherEnd: String
    let gatheringTime: String
    let gatherLongitude: String
    let postID: Int
    let nickName: String
    let postingTime: String
    let title: String
    let profileImageURL: String?
    let runningTime: String
    let age: String

    enum CodingKeys: String, CodingKey {
        case locationInfo
        case postUserID = "postUserId"
        case gender
        case runningTag
        case job
        case gatherLatitude
        case distance = "DISTANCE"
        case whetherEnd
        case gatheringTime
        case gatherLongitude
        case postID = "postId"
        case nickName
        case postingTime
        case title
        case profileImageURL = "profileImageUrl"
        case runningTime
        case age
    }
}

extension MainPostResElement {
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

    var coords: (lat: Float, long: Float)? {
        guard let latitude = Float(gatherLatitude),
              let longitude = Float(gatherLongitude)
        else {
            return nil
        }
        return (lat: latitude, long: longitude)
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

    var convertedPost: Post? {
        guard let runningTime = timeRunning,
              let gatherDate = gatherDate,
              let ageRange = ageRange,
              let coords = coords
        else { return nil }

        let id = postID
        let writerID = postUserID
        let writerName = nickName
        let writerProfileURL = profileImageURL
        let title = title
        let tag = runningTagType
        let locationInfo = locationInfo

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
            coord: coords
        )

        post.open = open && post.gatherDate > Date()
        post.marked = false
        post.attendance = false

        return post
    }
}
