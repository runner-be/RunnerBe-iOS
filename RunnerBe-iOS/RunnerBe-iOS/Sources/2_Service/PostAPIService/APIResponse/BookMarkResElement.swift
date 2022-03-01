//
//  BookMarkResElement.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/25.
//

import Foundation

// MARK: - BookMarkResElement

struct BookMarkResElement: Codable {
    let age: String
    let gatherLatitude: String
    let gender: String
    let postID: Int
    let title: String
    let runningTag: String
    let locationInfo: String
    let whetherEnd: String
    let runningTime: String
    let nickName: String
    let profileImageURL: String?
    let postUserID: Int
    let postingTime: String
    let gatheringTime: String
    let gatherLongitude: String
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case age
        case gatherLatitude
        case gender
        case postID = "postId"
        case title
        case runningTag
        case locationInfo
        case whetherEnd
        case runningTime
        case nickName
        case profileImageURL = "profileImageUrl"
        case postUserID = "postUserId"
        case postingTime
        case gatheringTime
        case gatherLongitude
        case userID = "userId"
    }
}

extension BookMarkResElement {
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

        post.open = open
        post.attendance = false
        post.marked = true
        return post
    }
}
