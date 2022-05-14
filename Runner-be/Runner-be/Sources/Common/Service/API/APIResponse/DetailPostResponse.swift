//
//  DetailPostResponse.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/01.
//

import Foundation

// MARK: - DetailPostResponse

struct DetailPostResponse: Codable {
    let postID: Int
    let postingTime: String
    let postUserID: Int
    let runningTag: String
    let title: String
    let gatheringTime: String
    let runningTime: String
    let gender: String
    let age: String
    let peopleNum: String
    let contents: String
    let gatherLongitude: String
    let gatherLatitude: String
    let locationInfo: String
    let whetherEnd: String

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case postingTime
        case postUserID = "postUserId"
        case runningTag
        case title
        case gatheringTime
        case runningTime
        case gender
        case age
        case peopleNum
        case contents
        case gatherLongitude
        case gatherLatitude
        case locationInfo
        case whetherEnd
    }
}

extension DetailPostResponse {
    var coords: (lat: Float, long: Float)? {
        guard let latitude = Float(gatherLatitude),
              let longitude = Float(gatherLongitude)
        else {
            return nil
        }
        return (lat: latitude, long: longitude)
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
        return RunningTag(name: runningTag)
    }

    var maxNumPeople: Int? {
        let nums = peopleNum.filter { $0.isNumber }.compactMap { Int(String($0)) }
        if nums.count != 1 { return nil }
        return nums[0]
    }

    var open: Bool {
        return whetherEnd == "N"
    }

    var convertedDetailPost: PostDetail? {
        guard let runningTime = timeRunning,
              let gatherDate = gatherDate,
              let ageRange = ageRange,
              let coords = coords,
              let maximumNum = maxNumPeople
        else { return nil }

        let id = postID
        let writerID = postUserID
        let writerName = ""
        // profileURL: nil
        let title = title
        let tag = runningTagType
        let locationInfo = locationInfo
        let content = contents

        var post = Post(
            ID: id,
            writerID: writerID,
            writerName: writerName,
            writerProfileURL: nil,
            title: title,
            tag: tag,
            runningTime: runningTime,
            gatherDate: gatherDate,
            ageRange: ageRange,
            gender: genderType,
            locationInfo: locationInfo,
            coord: coords,
            attendanceProfiles: []
        )

        post.open = open && post.gatherDate > Date()
        post.marked = false
        post.attendance = false

        return PostDetail(post: post, maximumNum: maximumNum, content: content)
    }
}
