//
//  PostDetailViewConfigItem.swift
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
    let locationInfo: String
    let placeName: String
    let placeExplain: String
    let date: String
    let afterParty: String
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
    init(from postDetail: PostDetail) {
        badge = postDetail.post.tag.name
        title = postDetail.post.title
        placeInfo = postDetail.post.locationInfo
        time = "\(postDetail.post.runningTime.hour)시간 \(postDetail.post.runningTime.minute)분"
        age = "\(postDetail.post.ageRange.min)-\(postDetail.post.ageRange.max)"
        date =
            DateUtil.shared.formattedString(for: postDetail.post.gatherDate, format: .custom(format: "M/d (E)"))
                + " "
                + DateUtil.shared.formattedString(for: postDetail.post.gatherDate, format: .ampm, localeId: "en_US")
                + " "
                + DateUtil.shared.formattedString(for: postDetail.post.gatherDate, format: .custom(format: "hh:mm")) // 3/31 (금)  AM 6:00
        long = postDetail.post.coord!.long
        lat = postDetail.post.coord!.lat
        range = 1000
        contents = postDetail.content
        numParticipant = "최대 \(postDetail.maximumNum)명"
        gender = postDetail.post.gender == .none ? postDetail.post.gender.name : (postDetail.post.gender.name + "만")

        if postDetail.post.afterParty == 1 {
            afterParty = "뒷풀이 있음"
        } else {
            afterParty = "뒷풀이 없음"
        }

        locationInfo = postDetail.post.locationInfo
        placeName = postDetail.post.placeName ?? ""
        placeExplain = postDetail.post.placeExplain ?? ""
    }
}
