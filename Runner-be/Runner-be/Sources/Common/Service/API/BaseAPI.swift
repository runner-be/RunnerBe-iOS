//
//  BaseAPI.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation

enum BaseAPI {
    static var url = URL(string: "https://www.runnerbe2.shop")!
}

enum APIResult<T> {
    case response(result: T)
    case error(alertMessage: String?)
}
