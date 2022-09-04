//
//  SettingCell.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import Then
import UIKit

class SettingCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        initialLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var titleLabel = UILabel().then { label in
        label.font = .iosBody15R
        label.textColor = .darkG1
    }

    private var detailLabel = UILabel().then { label in
        label.font = .iosBody15R
        label.textColor = .darkG2
    }

    private var pushSwitch = UISwitch().then { make in
        make.onTintColor = .primary
        make.tintColor = .darkG35
        make.backgroundColor = .darkG35
        make.isHidden = false
    }

    private func setupViews() {
        addSubviews([
            pushSwitch,
        ])
    }

    private func initialLayout() {
        pushSwitch.snp.makeConstraints { make in
            make.trailing.equalTo(self.contentView.snp.trailing)
        }
    }
}

extension SettingCell {
    static let id: String = "\(SettingCell.self)"
}
