//
//  Constatns.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/20.
//

import Alamofire

// 상수값 저장하는 클래스
struct Constant {
    static let BASE_URL = "https://www.runnerbe2.shop/"

    static var HEADERS: HTTPHeaders = ["x-access-token": UserInfo().token]
}
