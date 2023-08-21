//
//  String+regex.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/01.
//

import Foundation

extension String {
    func match(with pattern: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }
}
