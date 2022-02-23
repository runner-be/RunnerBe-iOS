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
    let locationInfo: String
    let runningTag: RunningTag
    let ageMin: Int
    let ageMax: Int
    let peopleNum: Int
    let contents: String
    let runnerGender: Gender
}
