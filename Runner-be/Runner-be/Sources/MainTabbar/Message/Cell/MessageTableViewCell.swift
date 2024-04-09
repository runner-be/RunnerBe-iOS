//
//  MessageTableViewCell.swift
//  Runner-be
//
//  Created by 이유리 on 2022/05/07.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class MessageTableViewCell: UITableViewCell {
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        initialLayout()
    }

    var messageProfile = UIImageView().then { view in
        view.snp.makeConstraints { profile in
            profile.width.equalTo(48)
            profile.height.equalTo(48)
        }

        view.image = UIImage(named: "iconsProfile48")
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
    }

    var nameLabel = UILabel().then { label in
        label.font = .pretendardRegular14
        label.textColor = .darkG35
        label.text = "글쓴이"
    }

    var postTitle = UILabel().then { label in
        label.font = .pretendardRegular16
        label.textColor = .darkG1
        label.text = "제목"
    }
}

extension MessageTableViewCell {
    private func setup() {
        backgroundColor = .darkG7
        contentView.addSubviews([
            messageProfile,
            nameLabel,
            postTitle,
        ])
    }

    private func initialLayout() {
        contentView.snp.makeConstraints { make in
            make.height.equalTo(72)
        }

        messageProfile.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView)
            make.leading.equalTo(contentView.snp.leading)
            make.centerY.equalTo(contentView.snp.centerY)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(postTitle.snp.bottom).offset(2)
            make.leading.equalTo(postTitle.snp.leading)
        }

        postTitle.snp.makeConstraints { make in
            make.top.equalTo(messageProfile.snp.top)
            make.leading.equalTo(messageProfile.snp.trailing).offset(12)
        }
    }
}

extension MessageTableViewCell {
    static let id: String = "\(MessageTableViewCell.self)"
}
