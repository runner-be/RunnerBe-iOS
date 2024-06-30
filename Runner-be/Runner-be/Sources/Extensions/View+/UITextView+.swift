//
//  UITextView+.swift
//  Runner-be
//
//  Created by 김창규 on 6/29/24.
//

import UIKit

extension UITextView {
    func numberOfLines() -> Int {
        guard let font = font else {
            return 0
        }

        // 인셋을 포함하여 텍스트 크기 계산
        let textSize = CGSize(
            width: frame.width - textContainerInset.left - textContainerInset.right,
            height: CGFloat.greatestFiniteMagnitude
        )

        // 텍스트의 높이를 인셋을 포함하여 계산
        let rHeight = lroundf(Float(sizeThatFits(textSize).height - textContainerInset.top - textContainerInset.bottom))

        // 라인 높이를 사용하여 줄 수 계산
        let charSize = lroundf(Float(font.lineHeight))
        let lineCount = rHeight / charSize
        return lineCount
    }
}
