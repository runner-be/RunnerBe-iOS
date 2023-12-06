//
//  JSONError.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation

enum JSONError: Error {
    case error(String)
}

extension JSONError {
    static var decoding: JSONError {
        .error("JSON Decoding Error")
    }

    static var toJson: JSONError {
        .error("Data to JSON Error")
    }
}
