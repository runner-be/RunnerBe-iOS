//
//  MessageChatTableViewCell.swift
//  Runner-be
//
//  Created by 이유리 on 2022/05/13.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class MessageChatLeftCell: UITableViewCell {
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup() // cell 세팅
        initialLayout() // cell 레이아웃 설정
    }

    private var profileImage = UIImageView().then { view in
        view.image = UIImage(named: "iconsProfile48")
    }

    private var nickName = UILabel().then { view in
        view.textColor = .darkG35
        view.font = .iosBody13R
        view.numberOfLines = 1
    }

    private var messageContent = UILabel().then { label in
        label.font = .iosBody15R
        label.textColor = .darkG1
        label.text = "메시지 내용"
        label.numberOfLines = 0
    }

    private var bubbleBackground = UIView().then { view in
        view.backgroundColor = .darkG55
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner] // 왼쪽 위 직각
        view.clipsToBounds = true
    }

    private var checkBox = UIButton().then { button in
        button.setImage(Asset.checkBoxIconEmpty.uiImage, for: .normal)
        button.isHidden = true
    }

    private var messageDate = UILabel().then { view in
        view.textColor = .darkG4
        view.font = .iosCaption11R
        view.numberOfLines = 1
    }

    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }

    var disposeBag = DisposeBag()
}

extension MessageChatLeftCell {
    static let id: String = "\(MessageChatLeftCell.self)"

    private func setup() {
        backgroundColor = .darkG7
        contentView.addSubviews([
            profileImage,
            bubbleBackground,
            nickName,
            messageContent,
            checkBox,
            messageDate,
        ])
    }

    private func initialLayout() {
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(self.contentView.snp.top)
            make.leading.equalTo(self.contentView.snp.leading)
            make.width.equalTo(28)
            make.height.equalTo(28)
        }

        nickName.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.top)
            make.leading.equalTo(profileImage.snp.trailing).offset(12)
        }

        bubbleBackground.snp.makeConstraints { make in
            make.top.equalTo(nickName.snp.bottom).offset(6)
            make.leading.equalTo(nickName.snp.leading)
        }

        checkBox.snp.makeConstraints { make in
            make.top.equalTo(bubbleBackground.snp.top)
            make.leading.equalTo(bubbleBackground.snp.trailing).offset(4)
        }

        messageDate.snp.makeConstraints { make in
            make.leading.equalTo(bubbleBackground.snp.trailing).offset(4)
            make.bottom.equalTo(bubbleBackground.snp.bottom)
        }
    }
}
