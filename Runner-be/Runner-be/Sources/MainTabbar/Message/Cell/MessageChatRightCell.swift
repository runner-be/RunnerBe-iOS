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

    private let messageImageTappedSubject = PublishSubject<UIImage>()
    var messageImageTapped: Observable<UIImage> {
        return messageImageTappedSubject.asObservable()
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

    private let messageImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 12
        $0.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner,
        ] // 오른쪽 위 직각
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor(white: 217.0 / 255.0, alpha: 1.0)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        messageImage.kf.cancelDownloadTask()
        messageImage.image = nil
    }

    var disposeBag = DisposeBag()

    private var imageSizeConstraint: Constraint?

    func configure(
        text: String?,
        date: Date?,
        imageUrls: [String?]
    ) {
        selectionStyle = .none
        separatorInset = .zero
        messageContent.text = text
        messageDate.text = DateUtil.shared.formattedString(for: date!, format: DateFormat.messageTime)

        if text == "" || text?.isEmpty ?? true {
            messageContent.snp.updateConstraints { make in
                make.top.equalTo(bubbleBackground.snp.top).offset(0)
                make.leading.equalTo(bubbleBackground.snp.leading).offset(0)
                make.trailing.equalTo(bubbleBackground.snp.trailing).offset(0)
                make.bottom.equalTo(bubbleBackground.snp.bottom).offset(0)
            }

        } else {
            messageContent.snp.updateConstraints { make in
                make.top.equalTo(bubbleBackground.snp.top).offset(12)
                make.leading.equalTo(bubbleBackground.snp.leading).offset(12)
                make.trailing.equalTo(bubbleBackground.snp.trailing).offset(-12)
                make.bottom.equalTo(bubbleBackground.snp.bottom).offset(-12)
            }
        }

        if imageUrls.compactMap({ $0 }).isEmpty {
            messageDate.snp.remakeConstraints {
                $0.trailing.equalTo(bubbleBackground.snp.leading).offset(-4)
                $0.bottom.equalTo(bubbleBackground.snp.bottom)
            }
        } else {
            messageDate.snp.remakeConstraints {
                $0.trailing.equalTo(messageImage.snp.leading).offset(-4)
                $0.bottom.equalTo(messageImage.snp.bottom)
            }
        }

        messageImage.kf.setImage(with: URL(string: imageUrls.compactMap { $0 }.first ?? ""))
        imageSizeConstraint?.update(offset: imageUrls.compactMap { $0 }.isEmpty ? 0 : 200)

        messageImage.rx.tapGesture()
            .compactMap { [weak self] _ in
                self?.messageImage.image
            }
            .bind(to: messageImageTappedSubject)
            .disposed(by: disposeBag)
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
        }

        messageContent.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(200)
            make.top.equalTo(bubbleBackground.snp.top).offset(12)
            make.leading.equalTo(bubbleBackground.snp.leading).offset(12)
            make.trailing.equalTo(bubbleBackground.snp.trailing).offset(-12)
            make.bottom.equalTo(bubbleBackground.snp.bottom).offset(-12)
        }

        messageImage.snp.makeConstraints {
            $0.top.equalTo(bubbleBackground.snp.bottom).offset(10)
            $0.right.equalTo(bubbleBackground)
            $0.bottom.equalToSuperview().offset(-12)
            self.imageSizeConstraint = $0.size.equalTo(0).constraint
        }

        messageDate.snp.makeConstraints { make in
            make.trailing.equalTo(bubbleBackground.snp.leading).offset(-4)
            make.bottom.equalTo(bubbleBackground.snp.bottom)
        }
    }
}
