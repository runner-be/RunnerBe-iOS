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
    let time: String
    let place: String
    let gender: String
    let ageText: String
    var writerAvr: UIImage?
    let writerName: String
    let writerProfileURL: String?
    var bookmarked: Bool
    let closed: Bool

    init(from post: Post) {
        id = post.ID
        title = post.title
        date =
            DateUtil.shared.formattedString(for: post.gatherDate, format: .custom(format: "M/d(E)"))
                + " "
                + DateUtil.shared.formattedString(for: post.gatherDate, format: .ampm, localeId: "en_US")
                + " "
                + DateUtil.shared.formattedString(for: post.gatherDate, format: .custom(format: "h:mm"))
        time = "\(post.runningTime.hour)시간 \(post.runningTime.minute)분"

        place = post.locationInfo
        switch post.gender {
        case .female, .male:
            gender = post.gender.name + L10n.Additional.Gender.limit
        case .none:
            gender = post.gender.name
        }

        ageText = "\(post.ageRange.min)-\(post.ageRange.max)"
        writerName = post.writerName
        writerProfileURL = post.writerProfileURL
        closed = !post.open
        bookmarked = post.marked
    }

    init(from post: Post, marked: Bool) {
        self.init(from: post)
        bookmarked = marked
    }

    var identity: String {
        "\(id)"
    }
}
