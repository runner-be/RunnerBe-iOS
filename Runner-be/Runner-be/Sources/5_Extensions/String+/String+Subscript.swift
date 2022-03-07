//
//  String+Subscript.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/14.
//

import Foundation

extension String {
    subscript(_ index: Int) -> String {
        let character = self[self.index(startIndex, offsetBy: index)]
        return String(character)
    }
}
