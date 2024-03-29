//
//  MyInfoViewWithChevron.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import SnapKit
import Then
import UIKit

final class MyInfoViewWithChevron: UIView {
    init() {
        super.init(frame: .zero)
        setupViews()
        initialLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var infoView = MyInfoView()

    var chevronBtn = UIButton().then { button in
        button.setImage(Asset.chevronRightXs.uiImage, for: .normal)
        button.imageView?.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
    }

    func setupViews() {
        addSubviews([
            infoView,
            chevronBtn,
        ])
    }

    func initialLayout() {
        infoView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
        }

        chevronBtn.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(infoView.snp.trailing).offset(5)
            make.trailing.equalTo(self.snp.trailing)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
}
