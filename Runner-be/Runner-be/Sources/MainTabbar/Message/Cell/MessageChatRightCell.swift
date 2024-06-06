//
//  MessageChatRightCell.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/30.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class MessageChatRightCell: UITableViewCell {
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        initialLayout()
    }

    var messageContent = UILabel().then { label in
        label.font = .pretendardRegular14
        label.textColor = .darkG1
        label.text = "메시지 내용"
        label.textColor = .black
        label.numberOfLines = 0
    }

    var bubbleBackground = UIView().then { view in
        view.backgroundColor = .darkG55
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner] // 오른쪽 위 직각
        view.clipsToBounds = true
    }

    var messageDate = UILabel().then { view in
        view.textColor = .darkG4
        view.font = .iosCaption11R
        view.numberOfLines = 1
    }

    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }

    var disposeBag = DisposeBag()
}

extension MessageChatRightCell {
    static let id: String = "\(MessageChatRightCell.self)"

    private func setup() {
        backgroundColor = .darkG7
        contentView.addSubviews([
            bubbleBackground,
            messageContent,
            messageDate,
        ])
    }

    private func initialLayout() {
        bubbleBackground.snp.makeConstraints { make in
            make.top.equalTo(self.contentView.snp.top)
            make.trailing.equalTo(self.contentView.snp.trailing).offset(-16)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-12)
        }

        messageContent.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(244)
            make.top.equalTo(bubbleBackground.snp.top).offset(12)
            make.leading.equalTo(bubbleBackground.snp.leading).offset(12)
            make.trailing.equalTo(bubbleBackground.snp.trailing).offset(-12)
            make.bottom.equalTo(bubbleBackground.snp.bottom).offset(-12)
        }

        messageDate.snp.makeConstraints { make in
            make.trailing.equalTo(bubbleBackground.snp.leading).offset(-4)
            make.bottom.equalTo(bubbleBackground.snp.bottom)
        }
    }
}
