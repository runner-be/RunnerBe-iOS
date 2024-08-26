//
//  PostingForm.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/23.
//

import Foundation

struct PostingForm {
    let title: String // 제목
    let gatheringTime: String // "YYYY-MM-dd hh:mm:ss"
    let runningTime: String // "hh:mm"
    let gatherLongitude: Float
    let gatherLatitude: Float
    let locationInfo: String // 위치명
    let placeName: String // 위치 주소
    let placeExplain: String // 위치 설명
    let runningTag: RunningTag
    let ageMin: Int
    let ageMax: Int
    let peopleNum: Int
    let contents: String
    let runnerGender: Gender
    let paceGrade: String
    let afterParty: Int
}

extension PostingForm: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(gatheringTime, forKey: .gatheringTime)
        try container.encode(runningTime, forKey: .runningTime)
        try container.encode(gatherLongitude, forKey: .gatherLongitude)
        try container.encode(gatherLatitude, forKey: .gatherLatitude)
        try container.encode(locationInfo, forKey: .locationInfo)
        try container.encode(placeName, forKey: .placeName)
        try container.encode(placeExplain, forKey: .placeExplain)
        try container.encode(runningTag.code, forKey: .runningTag)
        try container.encode(ageMin, forKey: .ageMin)
        try container.encode(ageMax, forKey: .ageMax)
        try container.encode(peopleNum, forKey: .peopleNum)
        try container.encode(contents, forKey: .contents)
        try container.encode(runnerGender.code, forKey: .runnerGender)
        try container.encode(paceGrade, forKey: .paceGrade)
        try container.encode(afterParty, forKey: .afterParty)
    }

    enum CodingKeys: CodingKey {
        case title
        case gatheringTime
        case runningTime
        case gatherLongitude
        case gatherLatitude
        case locationInfo
        case placeName
        case placeExplain
        case runningTag
        case ageMin
        case ageMax
        case peopleNum
        case contents
        case runnerGender
        case paceGrade
        case afterParty
    }
}

extension PostingForm: CustomDebugStringConvertible {
    var debugDescription: String {
        """
        PostingForm {
            title:  \(title)
            gatheringTime:  \(gatheringTime) // "YYYY-MM-dd hh:mm:ss"
            runningTime:  \(runningTime) // "hh:mm"
            gatherLatitude:  \(gatherLatitude) gatherLongitude:  \(gatherLongitude)
            locationInfo:  \(locationInfo)
            placeName:  \(placeName)
            placeExplain:  \(placeExplain)
            runningTag:  \(runningTag.name)
            ageMin:  \(ageMin) ageMax:  \(ageMax)
            runnerGender:  \(runnerGender)
            peopleNum:  \(peopleNum)
            contents:  \(contents)
        }
        """
    }
}
