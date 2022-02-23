//
//  PostFilter.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/23.
//

import Foundation

struct PostFilter {
    let latitude: Float
    let longitude: Float
    let wheterEnd: PostState
    let filter: FilterType
    let distanceFilter: Float
    let gender: Gender
    let ageMin: Int
    let ageMax: Int
    let runningTag: RunningTag
}
