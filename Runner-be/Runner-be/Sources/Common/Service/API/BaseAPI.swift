//
//  BaseAPI.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation

enum BaseAPI {
    #if DEBUG
//        static let url = URL(string: "https://dev.runnerbe2.shop")!
        static let url = URL(string: "https://new-runnerbe.shop")!

    #else
        static let url = URL(string: "https://new-runnerbe.shop")!
    #endif
}

enum APIResult<T> {
    case response(result: T)
    case error(alertMessage: String?)
}
