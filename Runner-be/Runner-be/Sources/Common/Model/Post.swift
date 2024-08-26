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

    let ageRange: (min: Int, max: Int)

    let gender: Gender

    let locationInfo: String
    let placeName: String?
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
            ageRange: \(ageRange.min) ~ \(ageRange.max),
            gender: \(gender.name),
            locationInfo: \(locationInfo),
            placeName: \(placeName ?? "nil"),
            placeExplain: \(placeExplain ?? "nil"),
            coord: lat - \(coord?.lat), long - \(coord?.long),
            open: \(open),
            marked: \(marked),
            attendance: \(attendance),
            whetherCheck: \(whetherCheck),
            attendanceProfiles: \(attendanceProfiles),
        }
        """
        return desc
    }
}
