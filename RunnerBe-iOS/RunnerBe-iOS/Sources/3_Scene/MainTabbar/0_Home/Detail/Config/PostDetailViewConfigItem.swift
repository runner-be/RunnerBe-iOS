//
//  PostDetailConfigurationItem.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/26.
//

import Foundation

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

struct PostDetailUserConfig {
    let nickName: String
    let age: String
    let gender: String
    let job: String
    let isPostOwner: Bool

    init(from user: User, owner: Bool) {
        nickName = user.nickName
        age = user.age
        let g = Gender(name: user.gender)
        switch g {
        case .female, .male:
            gender = user.gender + L10n.Additional.Gender.limit
        case .none: fallthrough
        default:
            gender = user.gender
        }
        job = user.job
        isPostOwner = owner
    }
}
