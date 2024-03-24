//
//  UserInfoHeader.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/25.
//

import SnapKit
import Then
import UIKit

final class UserInfoHeader: UIStackView {
    init() {
        super.init(frame: .zero)
        setup()
        initialLayout()
    }

    @available(*, unavailable)
    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var titleLabel = UILabel().then { label in
        label.font = .pretendardSemiBold16
        label.textColor = .darkG35
        label.text = "참여 러너"
    }

    var numLabel = UILabel().then { label in
        label.font = .pretendardSemiBold16
        label.textColor = .darkG35
        label.text = ""
    }

    private func setup() {
        axis = .horizontal
        alignment = .fill
        distribution = .equalSpacing
        spacing = 4
        addArrangedSubviews([titleLabel, numLabel])
    }

    private func initialLayout() {}
}
