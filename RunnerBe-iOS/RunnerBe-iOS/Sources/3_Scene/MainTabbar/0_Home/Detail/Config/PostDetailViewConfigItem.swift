//
//  PostDetailConfigurationItem.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/26.
//

import Foundation
import RxDataSources

struct PostDetailRunningConfig {
    let badge: String
    let title: String
    let placeInfo: String
    let date: String
    let time: String
    let gender: String
    let age: String
    let numParticipant: String
    let long: Float
    let lat: Float
    let range: Float
    let contents: String
}

extension PostDetailRunningConfig {
    init(from post: Post) {
        badge = post.runningTag
        title = post.title
        placeInfo = post.locationInfo
        time = post.runningTime

        age = "\(post.minAge)-\(post.maxAge)"
        date = post.gatheringTime
        numParticipant = String(post.numParticipantsLimit)
        long = post.longitude
        lat = post.latitude
        range = 1000
        contents = post.contents
        switch post.gender {
        case .female, .male:
            gender = post.gender.name + L10n.Additional.Gender.limit
        case .none: fallthrough
        default:
            gender = post.gender.name
        }
    }
}
