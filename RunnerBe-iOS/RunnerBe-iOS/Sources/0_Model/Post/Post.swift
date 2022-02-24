//
//  Post.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/23.
//

import Foundation
import SwiftyJSON

struct PostAPIResult: Codable {
    let postId: Int
    let postingTime: String // 2022-02-10T09:25:58.000Z
    let postUserId: Int
    let nickName: String
    let profileImageUrl: String?
    let title: String
    let runningTime: String // 소요시간
    let gatheringTime: String
    let gatherLongitude: String
    let gatherLatitude: String
    let locationInfo: String
    let runningTag: String // RunningTag
    let age: String // 20-65 (범위)
    let gender: String // 남성, 여성, 전체
    let DISTANCE: String // 모임 장소와 사용자 간 거리(Km)
    let whetherEnd: String // N Y 마감여부
    let job: String // DEV,EDU (쉼표로 구분)
}

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
    let runningTag: RunningTag
    let minAge: Int
    let maxAge: Int
    let gender: Gender
    let DISTANCE: Float
    let whetherEnd: PostState
    let job: [Job]
    var bookMarked = false

    init(from apiResult: PostAPIResult) {
        id = apiResult.postId
        postingTime = apiResult.postingTime
        writerID = apiResult.postUserId
        writerName = apiResult.nickName
        profileImageUrl = apiResult.profileImageUrl ?? ""
        title = apiResult.title
        runningTime = apiResult.runningTime
        gatheringTime = apiResult.gatheringTime
        longitude = Float(apiResult.gatherLongitude) ?? 0
        latitude = Float(apiResult.gatherLatitude) ?? 0
        locationInfo = apiResult.locationInfo
        runningTag = RunningTag(code: apiResult.runningTag)
        let ages = apiResult.age.components(separatedBy: "-")
        minAge = ages.count < 2 ? 20 : (Int(ages[0]) ?? 20)
        maxAge = ages.count < 2 ? 65 : (Int(ages[1]) ?? 65)
        gender = Gender(name: apiResult.gender)
        DISTANCE = Float(apiResult.DISTANCE) ?? 1000
        whetherEnd = PostState(from: apiResult.whetherEnd)
        job = apiResult.job.components(separatedBy: ",").reduce(into: [Job]()) {
            let job = Job(code: $1)
            if job == .none { return }
            $0.append(job)
        }
    }
}
