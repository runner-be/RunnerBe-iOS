//
//  UserInfoHeader.swift.swift
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
        label.font = .iosBody17Sb
        label.textColor = .darkG1
        label.text = "참여한 러너"
    }

    var numLabel = UILabel().then { label in
        label.font = .iosBody17R
        label.textColor = .darkG2
        label.text = "(1/8)"
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
