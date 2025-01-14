//
//  Post.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/23.
//

import Foundation
import SwiftyJSON

struct Post {
    let ID: Int
    let writerID: Int
    let writerName: String
    let writerProfileURL: String?

    let title: String
    let tag: RunningTag

    let runningTime: (hour: Int, minute: Int)
    let gatherDate: Date
    let gatheringId: Int?

    let ageRange: (min: Int, max: Int)

    let gender: Gender

    let placeName: String
    let placeAddress: String?
    let placeExplain: String?
    let coord: (lat: Float, long: Float)?

    var open: Bool = false
    var marked: Bool = false
    var attendance: Bool = false
    var whetherCheck: String = "N"

    var attendanceProfiles: [ProfileURL] = []

    var postingTime: Date
    let afterParty: Int
    let pace: String

    let logId: Int?

    let peopleNum: Int
}

struct PostDetail {
    let post: Post

    let maximumNum: Int
    let content: String
}

extension Post: CustomStringConvertible {
    var description: String {
        let desc = """
        {
            id: \(ID),
            postingTime: \(postingTime)
            writerId: \(writerID),
            writerName: \(writerName),
            writerProfileURL: \(writerProfileURL),
            title: \(title),
            tag: \(tag.name),
            runningTime: hour - \(runningTime.hour), minute - \(runningTime.minute),
            gatherDate: \(gatherDate),
            gatheringId: \(gatheringId),
            ageRange: \(ageRange.min) ~ \(ageRange.max),
            gender: \(gender.name),
            placeName: \(placeName),
            placeName: \(placeAddress ?? "nil"),
            placeExplain: \(placeExplain ?? "nil"),
            coord: lat - \(coord?.lat), long - \(coord?.long),
            open: \(open),
            marked: \(marked),
            attendance: \(attendance),
            whetherCheck: \(whetherCheck),
            attendanceProfiles: \(attendanceProfiles),
            logId: \(logId),
        }
        """
        return desc
    }
}

struct UserPagePost {
    let postId: Int
    let postingTime: String
    let postUserId: Int
    let title: String
    let gatheringTime: String
    let runningTag: String
    let age: String
    let gender: String
    let whetherEnd: String
    let pace: String
    let afterParty: Int
    let userId: Int
    let gatheringId: Int
    let logId: Int?
}
