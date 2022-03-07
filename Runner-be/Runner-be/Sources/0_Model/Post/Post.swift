//
//  Post.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/23.
//

import Foundation
import SwiftyJSON
//
// struct Post {
//    let id: Int
//    let postingTime: Date
//    let writerID: Int
//    let writerName: String
//    let profileImageUrl: String
//    let title: String
//    let runningTime: Int
//    let gatheringTime: Date
//    let longitude: Float
//    let latitude: Float
//    let locationInfo: String
//    let runningTag: String
//    let minAge: Int
//    let maxAge: Int
//    let gender: Gender
//    let DISTANCE: Float
//    let whetherEnd: String
//    let job: [Job]
//    var bookMarked = false
//    var contents: String = ""
//    let numParticipantsLimit: String
//    var attendance: Bool
// }

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
    let coord: (lat: Float, long: Float)?

    var open: Bool = false
    var marked: Bool = false
    var attendance: Bool = false
}

struct PostDetail {
    let post: Post

    let maximumNum: Int
    let content: String
}
