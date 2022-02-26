//
//  PostCellConfig.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/23.
//

import RxDataSources
import UIKit

struct PostCellConfig: Equatable, IdentifiableType {
    let id: Int
    let title: String
    let date: String
    let place: String
    let gender: String
    let ageText: String
    var writerAvr: UIImage?
    let writerName: String
    var bookmarked: Bool
    let closed: Bool

    init(from post: Post) {
        id = post.id
        title = post.title
        date = post.gatheringTime
        place = post.locationInfo
        switch post.gender {
        case .female, .male:
            gender = post.gender.name + L10n.Additional.Gender.limit
        case .none:
            gender = post.gender.name
        }
        ageText = "\(post.minAge)-\(post.maxAge)"
        writerName = post.writerName
        closed = post.whetherEnd == "Y"
        bookmarked = post.bookMarked
    }

    init(from post: Post, marked: Bool) {
        self.init(from: post)
        bookmarked = marked
    }

    var identity: String {
        "\(id)"
    }
}
