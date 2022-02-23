//
//  PostFilter.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/23.
//

import Foundation

struct PostFilter {
    var latitude: Double
    var longitude: Double
    var wheterEnd: PostState
    var filter: FilterType
    var distanceFilter: Float
    var gender: Gender
    var ageMin: Int
    var ageMax: Int
    var runningTag: RunningTag
    var jobFilter: Job
    var keywordSearch: String
}

extension PostFilter: CustomDebugStringConvertible {
    var debugDescription: String {
        """
        PostFilter {
            runningTag: \(runningTag.name)
            wheterEnd: \(wheterEnd)
            filter: \(filter)
            latitude: \(latitude) longitude: \(longitude)
            distanceFilter: \(distanceFilter)
            ageMin: \(ageMin) ageMax: \(ageMax)
            jobFilter: \(jobFilter.name)
            gender: \(gender.name)
            keywordSearch: \(keywordSearch)
        }
        """
    }
}
