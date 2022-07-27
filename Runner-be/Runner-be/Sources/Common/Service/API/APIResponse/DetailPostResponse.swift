//
//  DetailPostResponse.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/01.
//

import Foundation

// MARK: - DetailPostResponse

struct DetailPostResponse: Decodable {
    let whetherEnd: String?
    let profileURLList: [ProfileURL]?
    let nickName: String?
    let title: String?
    let gatherLongitude: String?
    let gatherLatitude: String?
    let runningTag: String?
    let postID: Int?
    let contents: String?
    let gatheringTime: String?
    let runningTime: String?
    let age: String?
    let postingTime: String?
    let postUserID: Int?
    let gender: String?
    let peopleNum: Int?
    let locationInfo: String?

    enum CodingKeys: String, CodingKey {
        case whetherEnd
        case profileURLList = "profileUrlList"
        case nickName
        case title
        case gatherLatitude
        case runningTag
        case postID = "postId"
        case gatheringTime
        case contents
        case gender
        case locationInfo
        case peopleNum
        case postUserID = "postUserId"
        case runningTime
        case age
        case gatherLongitude
        case postingTime
    }
}

extension DetailPostResponse {
    var coords: (lat: Float, long: Float)? {
        guard let gatherLatitude = gatherLatitude, let gatherLongitude = gatherLongitude,
              let latitude = Float(gatherLatitude),
              let longitude = Float(gatherLongitude)
        else {
            return nil
        }
        return (lat: latitude, long: longitude)
    }

    var ageRange: (min: Int, max: Int)? {
        let components = age?.components(separatedBy: "-")
        guard let components = components,
              components.count >= 2,
              let min = Int(components[0]),
              let max = Int(components[1])
        else { return nil }
        return (min: min, max: max)
    }

    var gatherDate: Date? { // "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let gatheringTime = gatheringTime else { return nil }
        let formatter = DateUtil.shared.dateFormatter
        formatter.dateFormat = DateFormat.apiDate.formatString
        var date = formatter.date(from: gatheringTime)
        date = date?.addingTimeInterval(TimeInterval(-TimeZone.current.secondsFromGMT()))
        return date
    }

    var timeRunning: (hour: Int, minute: Int)? {
        let hms = runningTime?.components(separatedBy: ":") // hour miniute seconds
        guard let hms = hms,
              hms.count > 2,
              let hour = Int(hms[0]),
              let minute = Int(hms[1])
        else { return nil }
        return (hour: hour, minute: minute)
    }

    var genderType: Gender {
        return Gender(name: gender ?? "")
    }

    var runningTagType: RunningTag {
        return RunningTag(name: runningTag ?? "")
    }

    var open: Bool {
        return whetherEnd == "N"
    }

    var convertedDetailPost: PostDetail? {
        guard let id = postID,
              let writerID = postUserID,
              let title = title,
              let locationInfo = locationInfo,
              let runningTime = timeRunning,
              let gatherDate = gatherDate,
              let ageRange = ageRange,
              let coords = coords,
              let maximumNum = peopleNum,
              let content = contents
        else { return nil }

        let writerName = ""
        // profileURL: nil
        let tag = runningTagType

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
