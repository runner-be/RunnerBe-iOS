//
//  PostAPIResult.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/25.
//

import Foundation

struct PostAPIResult: Codable {
    let postID, postUserID: Int
    let nickName: String?
    let profileImageURL: String?
    let title, runningTime, gatheringTime, locationInfo: String
    let runningTag: String?
    let age, gender: String
    let whetherEnd, job: String?
    let bookMark, attendance: Int?
    let postingTime, gatherLongitude, gatherLatitude, distance: String?
    let peopleNum, contents: String?
    let userID: Int?

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case postUserID = "postUserId"
        case nickName
        case profileImageURL = "profileImageUrl"
        case title, runningTime, gatheringTime, locationInfo, runningTag, age, gender, whetherEnd, job, bookMark, attendance, postingTime, gatherLongitude, gatherLatitude
        case distance = "DISTANCE"
        case peopleNum, contents
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
        var attend = false
        if let attendance = attendance {
            attend = (attendance == 1)
        }

        var bookmark = false
        if let mark = bookMark {
            bookmark = (mark == 1)
        }

        let post = Post(
            id: postID,
            postingTime: postingTime ?? "",
            writerID: postUserID,
            writerName: nickName ?? "",
            profileImageUrl: profileImageURL ?? "",
            title: title,
            runningTime: runningTime,
            gatheringTime: gatheringTime,
            longitude: Float(gatherLongitude ?? "") ?? 0,
            latitude: Float(gatherLatitude ?? "") ?? 0,
            locationInfo: locationInfo,
            runningTag: runningTag ?? "",
            minAge: ages.count < 2 ? 20 : (Int(ages[0]) ?? 20),
            maxAge: ages.count < 2 ? 65 : (Int(ages[1]) ?? 65),
            gender: Gender(name: gender),
            DISTANCE: Float(distance) ?? 1000,
            whetherEnd: whetherEnd ?? "",
            job: jobs,
            bookMarked: bookmark,
            contents: contents ?? "",
            numParticipantsLimit: peopleNum ?? "최대 -명",
            attendance: attend
        )

        return post
    }
}
