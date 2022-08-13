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

        checkBox.rx.tap
            .map {
                self.checkBox.isSelected.toggle()
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
        disposeBag = DisposeBag()
    }

    var disposeBag = DisposeBag()
    var tapCheck = PublishSubject<Bool>()
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
            make.top.equalTo(nickName.snp.bottom).offset(12)
            make.leading.equalTo(nickName.snp.leading)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-12)
        }

        messageContent.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(200)
            make.height.lessThanOrEqualTo(200)
            make.top.equalTo(bubbleBackground.snp.top).offset(12)
            make.leading.equalTo(bubbleBackground.snp.leading).offset(12)
            make.trailing.equalTo(bubbleBackground.snp.trailing).offset(-12)
            make.bottom.equalTo(bubbleBackground.snp.bottom).offset(-12)
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
