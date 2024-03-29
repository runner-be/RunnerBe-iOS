//
//  Constants.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/20.
//

import Alamofire

// 상수값 저장하는 클래스
enum Constant {
    #if DEBUG
        static let BASE_URL = "https://dev.runnerbe2.shop/"
    #else
        static let BASE_URL = "https://new-runnerbe.shop/"
    #endif

    static var HEADERS: HTTPHeaders = ["x-access-token": UserInfo().token]
}
