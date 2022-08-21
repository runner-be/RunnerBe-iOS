//
//  AlarmCell.swift
//  Runner-be
//
//  Created by 김신우 on 2022/08/21.
//

import RxCocoa
import RxSwift
import Then
import UIKit

class AlarmCell: UITableViewCell {
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        initialLayout()
    }

    func configure(with config: AlarmCellConfig) {
        titleLabel.text = config.title
        contentLabel.text = config.content
        timeLabel.text = config.timeDiff
        checkAlarm(isNew: config.isNew)
    }

    func checkAlarm(isNew: Bool) {
        contentView.backgroundColor = isNew ? .primarydarker : .clear
        backgroundColor = .clear
    }

    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }

    var disposeBag = DisposeBag()

    var titleLabel = UILabel().then { label in
        label.font = .iosBody15B
        label.textColor = .darkG1
        label.numberOfLines = 0
    }

    var contentLabel = UILabel().then { label in
        label.font = .iosBody15R
        label.textColor = .darkG2
        label.numberOfLines = 0
    }

    var timeLabel = UILabel().then { label in
        label.font = .iosBody13R
        label.textColor = .darkG35
    }
}

extension AlarmCell {
    private func setup() {
        selectionStyle = .none
        contentView.addSubviews([
            titleLabel,
            contentLabel,
            timeLabel,
        ])
    }

    private func initialLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(14)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-31)
        }

        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-31)
        }

        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(4)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-31)
            make.bottom.equalTo(contentView.snp.bottom).offset(-12)
        }
    }
}

extension AlarmCell {
    static let id: String = "\(BasicPostCell.self)"
}
