//
//  SelectBaseView.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/16.
//

import RxCocoa
import RxSwift
import Then
import UIKit

class SelectBaseView: UIView {
    var disposeBag = DisposeBag()

    var titleLabel = UILabel().then { label in
        label.text = ""
        label.font = .iosBody15R
        label.textColor = .darkG3
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
