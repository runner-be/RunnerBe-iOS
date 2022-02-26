//
//  PostAPIResult.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/25.
//

import Foundation

struct PostAPIResult: Codable {
    let postID: Int
    let postingTime: String
    let postUserID: Int
    let nickName, profileImageURL: String?
    let title, runningTime, gatheringTime, gatherLongitude: String
    let gatherLatitude, locationInfo: String
    let runningTag: String?
    let age, gender: String
    let distance, whetherEnd, job, peopleNum: String?
    let contents: String?
    let userID: Int?

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case postingTime
        case postUserID = "postUserId"
        case nickName
        case profileImageURL = "profileImageUrl"
        case title, runningTime, gatheringTime, gatherLongitude, gatherLatitude, locationInfo, runningTag, age, gender
        case distance = "DISTANCE"
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
        let numLimit = peopleNum == nil ? 2 : (Int(peopleNum!) ?? 2)

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
            contents: contents ?? "",
            numParticipantsLimit: numLimit
        )
    }
}
