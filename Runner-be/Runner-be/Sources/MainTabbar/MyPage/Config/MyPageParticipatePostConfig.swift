//
//  MyPageParticipatePostConfig.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/02.
//

import Foundation
import RxDataSources

enum ParticipateAttendState {
    case beforeManage
    case attendance
    case absence
}

struct MyPageParticipatePostConfig: Equatable, IdentifiableType {
    let cellConfig: PostCellConfig
    let state: ParticipateAttendState

    init(post: Post) {
        cellConfig = PostCellConfig(from: post)

        if post.whetherCheck == "N" { // 리더의 출석을 기다리는중
            state = .beforeManage
        } else if post.whetherCheck == "Y", post.attendance == true { // 참석
            state = .attendance
        } else { // 불참
            state = .absence
        }
    }

    var identity: String {
        "\(cellConfig.id)"
    }
}
