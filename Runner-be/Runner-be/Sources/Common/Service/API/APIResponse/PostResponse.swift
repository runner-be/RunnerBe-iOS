//
//  PostResponse.swift
//  Runner-be
//
//  Created by 김신우 on 2022/05/12.
//

import Foundation

struct PostResponse: Decodable {
    let postID: Int?
    let postUserID: Int?
    let postingTime: String? // 작성 시간

    // 작성자 정보
    let nickName: String?
    let profileImageURL: String?

    let title: String?
    let runningTime: String? // "01:30:00"
    let gatheringId: Int?
    let gatheringTime: String? // "2022-02-23T19:49:39.000z"
    let gatherLongitude: String?
    let gatherLatitude: String?
    let locationInfo: String?
    let placeName: String?
    let placeExplain: String?
    let runningTag: String?
    let age: String?
    let gender: String?
    let whetherEnd: String? // 마감여부
    let job: String?
    let peopleNum: Int?
    let contents: String?
    let userID: Int?
    let bookMark: Int?
    let attendance: Int?
    let whetherCheck: String?
    let distance: String?
    let profileURLList: [ProfileURL]?
    let afterParty: Int?
    let pace: String?

    let logId: Int?

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case postingTime
        case postUserID = "postUserId"
        case nickName
        case profileImageURL = "profileImageUrl"
        case title
        case runningTime
        case gatheringId
        case gatheringTime
        case gatherLongitude
        case gatherLatitude
        case locationInfo
        case placeName
        case placeExplain
        case runningTag
        case age
        case gender
        case whetherEnd
        case job
        case peopleNum
        case contents
        case userID = "userId"
        case bookMark
        case attendance
        case whetherCheck
        case distance = "DISTANCE"
        case profileURLList = "profileUrlList"
        case afterParty
        case pace
        case logId
    }
}

extension PostResponse {
    var jobTypes: [Job] {
        guard let job = job else { return [] }
        return job.components(separatedBy: ",").reduce(into: [Job]()) {
            let jType = Job(code: $1)
            if jType == .none { return }
            $0.append(jType)
        }
    }

    var coords: (lat: Float, long: Float)? {
        guard let gatherLatitude = gatherLatitude,
              let gatherLongitude = gatherLongitude,
              let latitude = Float(gatherLatitude),
              let longitude = Float(gatherLongitude)
        else {
            return nil
        }
        return (lat: latitude, long: longitude)
    }

    var ageRange: (min: Int, max: Int)? {
        guard let age = age else { return nil }
        let components = age.components(separatedBy: "-")
        guard components.count >= 2,
              let min = Int(components[0]),
              let max = Int(components[1])
        else { return nil }
        return (min: min, max: max)
    }

    var gatherDate: Date? { // "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let gatheringTime = gatheringTime else { return nil }
        return DateUtil.shared.apiDateStringToDate(gatheringTime)
    }

    var createTime: Date? {
        guard let postingTime = postingTime else { return nil }
        return DateUtil.shared.apiDateStringToDate(postingTime)
    }

    var timeRunning: (hour: Int, minute: Int)? {
        guard let runningTime = runningTime else { return nil }
        let hms = runningTime.components(separatedBy: ":") // hour miniute seconds
        guard hms.count > 2,
              let hour = Int(hms[0]),
              let minute = Int(hms[1])
        else { return nil }
        return (hour: hour, minute: minute)
    }

    var genderType: Gender {
        guard let gender = gender else { return .none }
        return Gender(name: gender)
    }

    var runningTagType: RunningTag? {
        guard let runningTag = runningTag else { return nil }
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
              let gatheringId = gatheringId,
              let postingTime = createTime,
              let ageRange = ageRange,
              let postID = postID,
              let postUserID = postUserID,
              let nickName = nickName,
              let postTitle = title,
              let runningTagType = runningTagType,
              let locationInformation = locationInfo,
              let pace = pace,
              let afterParty = afterParty
        else { return nil }

        let id = postID
        let writerID = postUserID
        let writerName = nickName
        let title = postTitle
        let tag = runningTagType
        let locationInfo = locationInformation

        var post = Post(
            ID: id,
            writerID: writerID,
            writerName: writerName,
            writerProfileURL: profileImageURL, // nullable
            title: title,
            tag: tag,
            runningTime: runningTime,
            gatherDate: gatherDate,
            gatheringId: gatheringId,
            ageRange: ageRange,
            gender: genderType,
            locationInfo: locationInfo,
            placeName: placeName,
            placeExplain: placeExplain,
            coord: coords, // nullable
            whetherCheck: whetherCheck ?? "N",
            attendanceProfiles: profileURLList ?? [],
            postingTime: postingTime,
            afterParty: afterParty,
            pace: pace,
            logId: logId
        )

        post.marked = marked
        post.attendance = attends
        post.whetherCheck = whetherCheck ?? "N"
        post.open = open && post.gatherDate > Date()

        return post
    }
}

struct ProfileURL: Decodable {
    let userID: Int?
    let profileImageURL: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case profileImageURL = "profileImageUrl"
    }
}

extension ProfileURL: CustomStringConvertible {
    var description: String {
        let desc = """
        {
            userID: \(userID),
            profileImageURL: \(profileImageURL),
        }
        """
        return desc
    }
}
