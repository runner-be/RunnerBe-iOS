//
//  NSMutableAttributedString+Style.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/09.
//

import UIKit

extension NSMutableAttributedString {
    func style(to string: String, attributes: [NSAttributedString.Key: Any]) -> NSMutableAttributedString {
        append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
}
