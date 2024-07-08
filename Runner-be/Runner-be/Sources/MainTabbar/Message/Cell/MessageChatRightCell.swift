//
//  MessageChatRightCell.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/30.
//

import Kingfisher
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
        setup() // cell 세팅
        initialLayout() // cell 레이아웃 설정
    }

    var messageContent = UILabel().then { label in
        label.font = .iosBody15R
        label.textColor = .black
        label.text = "메시지 내용"
        label.textColor = .black
        label.numberOfLines = 0
    }

    var bubbleBackground = UIView().then { view in
        view.backgroundColor = .primary
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner] // 오른쪽 위 직각
        view.clipsToBounds = true
    }

    var messageDate = UILabel().then { view in
        view.textColor = .darkG4
        view.font = .iosCaption11R
        view.numberOfLines = 1
    }

    var messageImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 12
        $0.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner,
        ] // 오른쪽 위 직각
        $0.clipsToBounds = true
    }

    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }

    var disposeBag = DisposeBag()

    private var imageSizeConstraint: Constraint?

    func configure(
        text: String?,
        date: Date?,
        imageUrls: [String]
    ) {
        selectionStyle = .none
        separatorInset = .zero
        messageContent.text = text
        messageDate.text = DateUtil.shared.formattedString(for: date!, format: DateFormat.messageTime)

        messageImage.kf.setImage(with: URL(string: imageUrls.first ?? ""))
        imageSizeConstraint?.update(offset: imageUrls.isEmpty ? 0 : 200)
    }
}

extension MessageChatRightCell {
    static let id: String = "\(MessageChatRightCell.self)"

    private func setup() {
        backgroundColor = .darkG7
        contentView.addSubviews([
            bubbleBackground,
            messageContent,
            messageImage,
            messageDate,
        ])
    }

    private func initialLayout() {
        bubbleBackground.snp.makeConstraints { make in
            make.top.equalTo(self.contentView.snp.top)
            make.trailing.equalTo(self.contentView.snp.trailing)
//            make.bottom.equalTo(self.contentView.snp.bottom).offset(-12)
        }

        messageContent.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(200)
            make.height.lessThanOrEqualTo(200)
            make.top.equalTo(bubbleBackground.snp.top).offset(12)
            make.leading.equalTo(bubbleBackground.snp.leading).offset(12)
            make.trailing.equalTo(bubbleBackground.snp.trailing).offset(-12)
            make.bottom.equalTo(bubbleBackground.snp.bottom).offset(-12)
        }

        messageImage.snp.makeConstraints {
            $0.top.equalTo(bubbleBackground.snp.bottom).offset(10)
            $0.right.equalTo(bubbleBackground)
            $0.bottom.equalToSuperview().offset(-12)
            self.imageSizeConstraint = $0.size.equalTo(200).constraint
        }

        messageDate.snp.makeConstraints { make in
            make.trailing.equalTo(bubbleBackground.snp.leading).offset(-4)
            make.bottom.equalTo(bubbleBackground.snp.bottom)
        }
    }
}
