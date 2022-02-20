//
//  MessageListItemView.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/20.
//

import SnapKit
import UIKit

class MessageListItemView: UITableViewCell {
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError()
    }

    init() {
        super.init(style: .default, reuseIdentifier: MessageListItemView.id)
        setup()
    }

    override init(style: UITableViewCell.CellStyle = .default, reuseIdentifier _: String?) {
        super.init(style: style, reuseIdentifier: MessageListItemView.id)
        setup()
    }

    private func setup() {
        setupViews()
        initialLayout()
    }

    override func prepareForReuse() {}

    var profileImage = UIImageView().then { view in
        view.image = Asset.profileEmptyIcon.uiImage
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
    }

    var titleLabel = UILabel().then { label in
        label.font = .iosBody15B
        label.textColor = .darkG2
        label.text = "닉네임"
    }

    var postTitleLabel = UILabel().then { label in
        label.font = .iosBody13R
        label.textColor = .darkG35
        label.text = "게시글 제목"
    }

    var deleteCheckBox = UIButton().then { button in
        button.setImage(Asset.checkBoxIconEmpty.uiImage.withTintColor(.darkG35), for: .normal)
        button.setImage(Asset.checkBoxIconChecked.uiImage.withTintColor(.primary), for: .selected)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.backgroundColor = .clear
        button.isSelected = true
    }

    private lazy var labelVStackView = UIStackView.make(
        with: [titleLabel, postTitleLabel],
        axis: .vertical,
        alignment: .leading,
        distribution: .equalSpacing,
        spacing: 1
    )

    private func setupViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubviews([
            profileImage,
            labelVStackView,
            deleteCheckBox,
        ])
    }

    private func initialLayout() {
        profileImage.snp.makeConstraints { make in
            make.width.equalTo(48)
            make.top.equalTo(contentView.snp.top).offset(12)
            make.bottom.equalTo(contentView.snp.bottom).offset(-15)
        }
        profileImage.layer.cornerRadius = 24

        labelVStackView.snp.makeConstraints { make in
            make.centerY.equalTo(profileImage.snp.centerY)
            make.leading.equalTo(profileImage.snp.trailing).offset(12)
        }

        deleteCheckBox.snp.makeConstraints { make in
            make.centerY.equalTo(profileImage.snp.centerY)
            make.trailing.equalTo(contentView.snp.trailing)
        }
    }
}

extension MessageListItemView {
    static var id: String {
        "\(MessageListItemView.self)"
    }

    static var itemHeight: CGFloat {
        return 48.0
    }
}
