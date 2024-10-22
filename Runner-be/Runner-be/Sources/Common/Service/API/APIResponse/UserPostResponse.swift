//
//  UserPostResponse.swift
//  Runner-be
//
//  Created by 김창규 on 10/22/24.
//

import Foundation

struct UserPostResponse: Decodable {
    let postId: Int
    let postingTime: String
    let postUserId: Int
    let title: String
    let gatheringTime: String
    let runningTag: String
    let age: String
    let gender: String
    let whetherEnd: String
    let pace: String
    let afterParty: Int
    let userId: Int
    let gatheringId: Int
    let logId: Int?
    let runningTime: String? // "01:30:00"

    var gatherDate: Date? { // "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return DateUtil.shared.apiDateStringToDate(gatheringTime)
    }

    var timeRunning: (hour: Int, minute: Int)? {
        guard let runningTime = runningTime else { return nil }
        let hms = runningTime.components(separatedBy: ":") // hour miniute seconds
        guard hms.count > 2,
              let hour = Int(hms[0]),
              let minute = Int(hms[1])
        else { return nil }
        return (hour: hour, minute: minute)
    }

    var convertedPost: UserPost? {
        guard let gatherDate = gatherDate else { return nil }
        return UserPost(
            postId: postId,
            gatherDate: gatherDate,
            title: title,
            gender: gender,
            age: age,
            afterParty: afterParty,
            pace: pace,
            logId: logId,
            runningTime: timeRunning ?? (hour: 1, minute: 0)
        )
    }
}

struct UserPost {
    let postId: Int
    let gatherDate: Date
    let title: String
    let gender: String
    let age: String
    let afterParty: Int
    let pace: String
    let logId: Int?
    let runningTime: (hour: Int, minute: Int)
}
