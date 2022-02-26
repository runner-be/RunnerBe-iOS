//
//  Post.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/23.
//

import Foundation
import SwiftyJSON

struct Post {
    let id: Int
    let postingTime: String
    let writerID: Int
    let writerName: String
    let profileImageUrl: String
    let title: String
    let runningTime: String
    let gatheringTime: String
    let longitude: Float
    let latitude: Float
    let locationInfo: String
    let runningTag: String
    let minAge: Int
    let maxAge: Int
    let gender: Gender
    let DISTANCE: Float
    let whetherEnd: String
    let job: [Job]
    var bookMarked = false
    var contents: String = ""
    let numParticipantsLimit: Int
}
