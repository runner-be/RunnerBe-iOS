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

    private var messageProfile = UIImageView().then { view in
        view.snp.makeConstraints { profile in
            profile.width.equalTo(48)
            profile.height.equalTo(48)
        }

        view.image = UIImage(named: "iconsProfile48")
    }

    private var nameLabel = UILabel().then { label in
        label.font = .iosBody15B
        label.textColor = .darkG2
        label.text = "닉네임"
    }

    private var postTitle = UILabel().then { label in
        label.font = .iosBody13R
        label.textColor = .darkG35
        label.text = "게시글 제목"
    }

    private var divider = UIView().then { view in
        view.snp.makeConstraints { divider in
            divider.height.equalTo(1)
        }
        view.backgroundColor = .darkG35
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
            divider,
        ])
    }

    private func initialLayout() {
        messageProfile.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView)
            make.leading.equalTo(contentView.snp.leading).offset(16)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(messageProfile.snp.top)
            make.leading.equalTo(messageProfile.snp.trailing).offset(12)
        }

        postTitle.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.equalTo(nameLabel.snp.leading)
        }

        divider.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
}

extension MessageTableViewCell {
    static let id: String = "\(MessageTableViewCell.self)"

    static let size: CGSize = {
        let hMargin: CGFloat = 16
        let width: CGFloat = UIScreen.main.bounds.width - hMargin * 2
        let height: CGFloat = 76
        return CGSize(width: width, height: height)
    }()
}
