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
//    enum State {
//        case open
//        case closed
//    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup() // cell 세팅
        initialLayout() // cell 레이아웃 설정
    }

    var messageProfile = UIImageView().then { view in
        view.snp.makeConstraints { profile in
            profile.width.equalTo(48)
            profile.height.equalTo(48)
        }

        view.image = UIImage(named: "iconsProfile48")
    }

    var nameLabel = UILabel().then { label in
        label.font = .iosBody13R
        label.textColor = .darkG3
        label.text = "글쓴이"
    }

    var postTitle = UILabel().then { label in
        label.font = .iosBody17Sb
        label.textColor = .darkG1
        label.text = "제목"
    }

//    private var divider = UIView().then { view in
//        view.snp.makeConstraints { divider in
//            divider.height.equalTo(1)
//        }
//        view.backgroundColor = .darkG35
//    }

    private var checkBox = UIButton().then { view in
        view.setImage(UIImage(named: "CheckBoxIcon_Empty"), for: .normal)
//        view.setImage(UIImage(named:"CheckBoxIcon_Checked"), for: .focused)
        view.isHidden = true // 쪽지 삭제에서 체크박스 등장할 예정
    }

//    func configure(with item: PostCellConfig) {
//        postInfoView.configure(with: item)
//        postState = item.closed ? .closed : .open
//    }
//
//    override func prepareForReuse() {
//        postState = .open
//
//        postInfoView.reset()
//        disposeBag = DisposeBag()
//    }
//
//    var disposeBag = DisposeBag()
//
//    var postState: State = .closed {
//        didSet {
//            updateCover()
//        }
//    }
//
//    var blurAlpha: CGFloat = 0.7
//
//    var postInfoView = BasicPostInfoView()
//
//    private var cover: UIView?
//
//    private func updateCover() {
//        cover?.removeFromSuperview()
//        if postState == .open {
//            cover = nil
//            return
//        }
//
//        let cover = UIView()
//        addSubview(cover)
//        cover.snp.makeConstraints { make in
//            make.top.equalTo(self.snp.top)
//            make.leading.equalTo(self.snp.leading)
//            make.trailing.equalTo(self.snp.trailing)
//            make.bottom.equalTo(self.snp.bottom)
//        }
//
//        switch postState {
//        case .closed:
//            let coverLabel = UILabel()
//            coverLabel.font = .iosBody15R
//            coverLabel.textColor = .darkG35
//            coverLabel.text = L10n.Home.PostList.Cell.Cover.closed
//
//            let blur = UIBlurEffect(style: .dark)
//            let blurView = UIVisualEffectView(effect: blur)
//            blurView.alpha = blurAlpha
//            blurView.frame = cover.bounds
//            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            cover.addSubview(blurView)
//
//            cover.addSubview(coverLabel)
//            coverLabel.snp.makeConstraints { make in
//                make.centerX.equalTo(cover.snp.centerX)
//                make.centerY.equalTo(cover.snp.centerY)
//            }
//        case .open:
//            break
//        }
//
//        self.cover = cover
//    }
}

extension MessageTableViewCell {
    private func setup() {
        backgroundColor = .darkG7
        contentView.addSubviews([
            messageProfile,
            nameLabel,
            postTitle,
            checkBox,
        ])
    }

    private func initialLayout() {
        contentView.snp.makeConstraints { make in
            make.height.equalTo(72)
        }

        messageProfile.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView)
            make.leading.equalTo(contentView.snp.leading).offset(16)
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
