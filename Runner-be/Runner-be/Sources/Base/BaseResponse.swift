//
//  BaseResponse.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/21.
//

import Foundation

struct BaseResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
}
