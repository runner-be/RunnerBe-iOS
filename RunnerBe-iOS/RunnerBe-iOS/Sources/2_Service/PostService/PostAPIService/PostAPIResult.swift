//
//  PostAPIResult.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/25.
//

import Foundation

struct PostAPIResult: Codable {
//    let postId: Int
//    let postingTime: String // 2022-02-10T09:25:58.000Z
//    let postUserId: Int
//    let nickName: String?
//    let profileImageUrl: String?
//    let title: String
//    let runningTime: String // 소요시간
//    let gatheringTime: String
//    let gatherLongitude: String
//    let gatherLatitude: String
//    let locationInfo: String
//    let runningTag: String // RunningTag
//    let age: String // 20-65 (범위)
//    let gender: String // 남성, 여성, 전체
//    let DISTANCE: String? // 모임 장소와 사용자 간 거리(Km)
//    let whetherEnd: String // N Y 마감여부
//    let job: String // DEV,EDU (쉼표로 구분)
//    var content: String?
    let age: String
    let postID: Int
    let runningTag: String?
    let postingTime, locationInfo, gender, gatheringTime: String
    let gatherLongitude: String
    let nickName: String?
    let runningTime, title: String
    let distance: String?
    let profileImageURL: String?
    let gatherLatitude: String
    let postUserID: Int
    let whetherEnd, job, peopleNum, contents: String?
    let userID: Int?

    enum CodingKeys: String, CodingKey {
        case age
        case postID = "postId"
        case runningTag, postingTime, locationInfo, gender, gatheringTime, gatherLongitude, nickName, runningTime, title
        case distance = "DISTANCE"
        case profileImageURL = "profileImageUrl"
        case gatherLatitude
        case postUserID = "postUserId"
        case whetherEnd, job, peopleNum, contents
        case userID = "userId"
    }
}

extension PostAPIResult {
    var post: Post {
        let ages = age.components(separatedBy: "-")
        let distance = distance ?? "1000"
        var jobs = [Job]()
        if let j = job {
            jobs = j.components(separatedBy: ",").reduce(into: [Job]()) {
                let job = Job(code: $1)
                if job == .none { return }
                $0.append(job)
            }
        }

        return Post(
            id: postID,
            postingTime: postingTime,
            writerID: postUserID,
            writerName: nickName ?? "",
            profileImageUrl: profileImageURL ?? "",
            title: title,
            runningTime: runningTime,
            gatheringTime: gatheringTime,
            longitude: Float(gatherLongitude) ?? 0,
            latitude: Float(gatherLatitude) ?? 0,
            locationInfo: locationInfo,
            runningTag: RunningTag(code: runningTag ?? ""),
            minAge: ages.count < 2 ? 20 : (Int(ages[0]) ?? 20),
            maxAge: ages.count < 2 ? 65 : (Int(ages[1]) ?? 65),
            gender: Gender(name: gender),
            DISTANCE: Float(distance) ?? 1000,
            whetherEnd: PostState(from: whetherEnd ?? ""),
            job: jobs,
            contents: contents ?? ""
        )
    }
}
