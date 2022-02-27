//
//  PostCellConfig.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import Foundation
import RxDataSources

enum PostAttendState {
    case beforeAttendable
    case attendable
    case attend
    case absence
}

struct MyPagePostConfig: Equatable, IdentifiableType {
    let cellConfig: PostCellConfig
    let state: PostAttendState

    init(post: Post) {
        cellConfig = PostCellConfig(from: post)

        // 서버에 상태 반영되면 처리
        switch post.id % 4 {
        case 0:
            state = .beforeAttendable
        case 1:
            state = .attendable
        case 2:
            state = .absence
        case 3:
            state = .attend
        default:
            state = .beforeAttendable
        }
    }

    var identity: String {
        "\(cellConfig.id)"
    }
}
