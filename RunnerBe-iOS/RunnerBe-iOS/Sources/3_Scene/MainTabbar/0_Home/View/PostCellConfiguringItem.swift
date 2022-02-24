//
//  PostCellConfiguringItem.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/23.
//

import RxDataSources
import UIKit

struct PostCellConfiguringItem: Equatable {
    let title: String
    let date: String
    let place: String
    let gender: String
    let ageText: String
    var writerAvr: UIImage?
    let writerName: String
    let bookmarked: Bool
    let closed: Bool

    init(from post: Post) {
        title = post.title
        date = post.gatheringTime
        place = post.locationInfo
        gender = post.gender.name
        ageText = "\(post.minAge)-\(post.maxAge)"
        writerName = post.writerName
        closed = post.whetherEnd != .open
        bookmarked = false
    }
}
