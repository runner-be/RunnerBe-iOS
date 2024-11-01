//
//  MessageChatLeftCell.swift
//  Runner-be
//
//  Created by 이유리 on 2022/05/13.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

protocol MessageChatReportDelegate: AnyObject {
    func checkButtonTap(cell: MessageChatLeftCell) // 체크박스 눌렀을 때 index를 받기 위한 delegate
}

class MessageChatLeftCell: UITableViewCell {
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var delegate: MessageChatReportDelegate?

    private let messageImageTappedSubject = PublishSubject<UIImage>()
    var messageImageTapped: Observable<UIImage> {
        return messageImageTappedSubject.asObservable()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup() // cell 세팅
        initialLayout() // cell 레이아웃 설정

        checkBox.rx.tap
            .map {
                self.checkBox.isSelected.toggle()
                self.delegate?.checkButtonTap(cell: self)
                return self.checkBox.isSelected
            }
            .subscribe(tapCheck)
            .disposed(by: disposeBag)
    }

    var profileImage = UIImageView().then { view in
        view.image = UIImage(named: "iconsProfile48")
    }

    var nickName = UILabel().then { view in
        view.textColor = .darkG35
        view.font = .iosBody13R
        view.numberOfLines = 1
    }

    var messageContent = UILabel().then { label in
        label.font = .iosBody15R
        label.textColor = .darkG1
        label.text = "메시지 내용"
        label.textColor = .black
        label.numberOfLines = 0
    }

    var bubbleBackground = UIView().then { view in
        view.backgroundColor = .darkG55
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner] // 왼쪽 위 직각
        view.clipsToBounds = true
    }

    var checkBox = UIButton().then { button in
        button.setImage(Asset.checkBoxIconEmpty.uiImage.withTintColor(.darkG35), for: .normal)
        button.setImage(Asset.checkBoxIconChecked.uiImage.withTintColor(.primary), for: .selected)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.backgroundColor = .clear
        button.isSelected = false
        button.isHidden = true
    }

    private let messageImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 12
        $0.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner,
            .layerMaxXMinYCorner,
        ] // 왼쪽 위 직각
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor(white: 217.0 / 255.0, alpha: 1.0)
    }

    override var isSelected: Bool {
        get { checkBox.isSelected }
        set {
            checkBox.isSelected = newValue
            tapCheck.onNext(newValue)
        }
    }

    var messageDate = UILabel().then { view in
        view.textColor = .darkG4
        view.font = .iosCaption11R
        view.numberOfLines = 1
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        messageImage.kf.cancelDownloadTask()
        messageImage.image = nil
        messageDate.text = nil
    }

    var disposeBag = DisposeBag()
    var tapCheck = PublishSubject<Bool>()
    private var imageSizeConstraint: Constraint?

    func configure(
        text: String?,
        nickname: String?,
        date: Date?,
        imageUrls: [String?]
    ) {
        selectionStyle = .none
        separatorInset = .zero
        messageContent.text = text
        nickName.text = nickname
        messageDate.text = DateUtil.shared.formattedString(for: date!, format: DateFormat.messageTime)

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

extension MessageChatLeftCell {
    static let id: String = "\(MessageChatLeftCell.self)"

    private func setup() {
        backgroundColor = .darkG7
        contentView.addSubviews([
            profileImage,
            bubbleBackground,
            nickName,
            messageContent,
            messageImage,
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
            make.top.equalTo(nickName.snp.bottom).offset(12)
            make.leading.equalTo(nickName.snp.leading)
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
            $0.left.equalTo(bubbleBackground)
            $0.bottom.equalToSuperview().offset(-12)
            self.imageSizeConstraint = $0.size.equalTo(0).constraint
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
