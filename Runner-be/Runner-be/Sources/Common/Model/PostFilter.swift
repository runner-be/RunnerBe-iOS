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
    var postState: PostState
    var filter: FilterType
    var distanceFilter: Float
    var gender: Gender
    var ageMin: Int
    var ageMax: Int
    var runningTag: RunningTag
    var jobFilter: Job
    var paceFilter: [String]
    var keywordSearch: String
    var page: Int
    var pageSize: Int
}

extension PostFilter: CustomDebugStringConvertible {
    var debugDescription: String {
        """
        PostFilter {
            runningTag: \(runningTag)
            postState: \(postState)
            filter: \(filter)
            latitude: \(latitude) longitude: \(longitude)
            distanceFilter: \(distanceFilter)
            ageMin: \(ageMin) ageMax: \(ageMax)
            jobFilter: \(jobFilter)
            paceFilter: \(paceFilter)
            gender: \(gender.name)
            keywordSearch: \(keywordSearch)
            page: \(page)
            pageSize: \(pageSize)
        }
        """
    }
}
