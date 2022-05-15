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

class MessageChatTableViewCell: UITableViewCell {
    private var direction = "left"

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup() // cell 세팅
        initialLayout() // cell 레이아웃 설정
    }

    private var partnerProfile = UIImageView().then { view in
        view.image = UIImage(named: "iconsProfile48")
    }

    private var messageContent = UILabel().then { label in
        label.font = .iosBody15R
        label.textColor = .darkG1
        label.text = "메시지 내용"
        label.numberOfLines = 0
    }

    private var partnerBubbleBackground = UIView().then { view in
        view.backgroundColor = .darkG6
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner] // 왼쪽 위 직각
        view.clipsToBounds = true
    }

    private var myBubbleBackground = UIView().then { view in
        view.backgroundColor = .darkG6
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner] // 오른쪽 위 직각
        view.clipsToBounds = true
    }

    private var messageDate = UILabel().then { view in
        view.textColor = .darkG4
        view.font = .iosCaption11R
        view.numberOfLines = 1
    }

//    func configure(with item: PostCellConfig) {
//        postInfoView.configure(with: item)
//        postState = item.closed ? .closed : .open
//    }
//
    override func prepareForReuse() {
//        postState = .open
//
//        postInfoView.reset()
        disposeBag = DisposeBag()
    }

//
    var disposeBag = DisposeBag()
//
//    var postState: State = .closed {
//        didSet {
//            updateCover()
//        }
//    }
//
}

extension MessageChatTableViewCell {
    static let id: String = "\(MessageChatTableViewCell.self)"

    private func setup() {
        backgroundColor = .darkG7
        contentView.addSubviews([
            partnerProfile,
            partnerBubbleBackground,
            myBubbleBackground,
            messageContent,
            messageDate,
        ])
    }

    private func initialLayout() {
//        if (direction=="left"){
//            partnerProfile.isHidden = false
//            partnerBubbleBackground.
//        }
//        else{
//            partnerProfile.isHidden = true
//        }
        partnerProfile.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(8)
            make.leading.equalTo(self.snp.leading)
            make.width.equalTo(28)
            make.height.equalTo(28)
        }

        partnerBubbleBackground.snp.makeConstraints { make in
            make.top.equalTo(partnerProfile.snp.top)
            make.leading.equalTo(partnerProfile.snp.trailing).offset(12)
        }

        messageContent.snp.makeConstraints { make in
            if direction == "left" { // 상대 메시지
                make.top.equalTo(partnerBubbleBackground.snp.top).offset(11)
                make.top.equalTo(partnerBubbleBackground.snp.leading).offset(13)
                make.top.equalTo(partnerBubbleBackground.snp.bottom).offset(-12)
                make.top.equalTo(partnerBubbleBackground.snp.trailing).offset(-13)
            } else {
                make.top.equalTo(myBubbleBackground.snp.top).offset(11)
                make.top.equalTo(myBubbleBackground.snp.leading).offset(13)
                make.top.equalTo(myBubbleBackground.snp.bottom).offset(-12)
                make.top.equalTo(myBubbleBackground.snp.trailing).offset(-13)
            }
        }

        messageDate.snp.makeConstraints { make in
            if direction == "left" { // 상대 메시지
                make.top.equalTo(partnerBubbleBackground.snp.bottom).offset(6)
                make.top.equalTo(partnerBubbleBackground.snp.leading)
            } else {
                make.top.equalTo(myBubbleBackground.snp.bottom)
                make.top.equalTo(myBubbleBackground.snp.leading)
            }
        }
    }
}
