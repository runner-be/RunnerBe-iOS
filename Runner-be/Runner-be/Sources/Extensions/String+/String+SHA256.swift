//
//  String+SHA256.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/15.
//

import CryptoKit
import Foundation

extension String {
    var sha256: String {
        guard let data = data(using: .utf8)
        else { return self }
        let sha256 = SHA256.hash(data: data)
        return sha256.compactMap { String(format: "%02x", $0) }.joined()
    }
}
