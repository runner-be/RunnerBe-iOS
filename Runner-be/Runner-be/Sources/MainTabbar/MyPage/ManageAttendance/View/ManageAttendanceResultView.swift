//
//  ManageAttendanceResultView.swift
//  Runner-be
//
//  Created by 이유리 on 2022/08/13.
//

import SnapKit
import Then
import UIKit

final class ManageAttendanceResultView: UIView {
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero)
        setup()
        initialLayout()
    }

    private var background = UIView().then { view in
        view.backgroundColor = .darkG6
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
    }

    var label = UILabel().then { view in
        view.font = .iosBody15R
        view.text = "테스트"
        view.textColor = .darkG35
    }

    private func setup() {
        addSubviews([
            background,
        ])

        background.addSubview(label)
    }

    private func initialLayout() {
        background.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
            make.height.equalTo(44)
        }

        label.snp.makeConstraints { make in
            make.centerX.equalTo(self.background.snp.centerX)
            make.centerY.equalTo(self.background.snp.centerY)
        }
    }
}
