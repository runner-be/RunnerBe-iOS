//
//  LogPartners.swift
//  Runner-be
//
//  Created by 김창규 on 10/1/24.
//

import Foundation

struct LogPartners: Decodable {
    let userId: Int
    let logId: Int?
    let nickname: String
    let profileImageUrl: String?
    let isOpened: Int?
    var stampCode: String?
}
