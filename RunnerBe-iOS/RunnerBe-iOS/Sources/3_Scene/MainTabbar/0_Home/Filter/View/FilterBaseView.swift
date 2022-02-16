//
//  FilterBaseView.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/16.
//

import Then
import UIKit

class FilterBaseView: UIView {
    var titleLabel = UILabel().then { label in
        label.text = ""
        label.font = .iosBody17Sb
        label.textColor = .darkG35
    }

    var contentView = UIView().then { view in
        view.backgroundColor = .clear
    }

    func setupViews() {
        addSubviews([
            titleLabel,
            contentView,
        ])
    }

    func initialLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
        }

        contentView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
}
