//
//  TextFieldWithPadding.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import UIKit

class TextFieldWithPadding: UITextField {
    var textPadding: UIEdgeInsets?

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        if let padding = textPadding {
            return rect.inset(by: padding)
        }
        return rect
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        if let padding = textPadding {
            return rect.inset(by: padding)
        }
        return rect
    }
}
