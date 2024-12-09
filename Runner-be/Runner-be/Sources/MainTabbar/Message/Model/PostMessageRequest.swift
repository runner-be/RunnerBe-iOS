//
//  PostMessageRequest.swift
//  Runner-be
//
//  Created by 이유리 on 2022/08/13.
//

import Foundation

struct PostMessageRequest: Encodable {
    var content: String?
    var imageUrl: String? = nil
}
