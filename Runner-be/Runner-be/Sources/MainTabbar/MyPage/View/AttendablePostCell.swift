//
//  AttendablePostCell.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class AttendablePostCell: UICollectionViewCell {
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
        initialLayout()
    }

    func configure(with item: MyPagePostConfig) {
        postInfoView.configure(with: item.cellConfig)
        update(with: item.state)
    }

    override func prepareForReuse() {
        postInfoView.reset()
        disposeBag = DisposeBag()
    }

    var disposeBag = DisposeBag()

    var postInfoView = BasicPostInfoView()

    var attendButton = UIButton().then { button in
        button.setTitle(L10n.MyPage.Main.Cell.Button.Attend.title, for: .normal)
        button.setTitleColor(UIColor.darkG6, for: .normal)
        button.setBackgroundColor(UIColor.primary, for: .normal)

        button.setTitle(L10n.MyPage.Main.Cell.Button.Attend.title, for: .disabled)
        button.setTitleColor(UIColor.darkG4, for: .disabled)
        button.setBackgroundColor(.clear, for: .disabled)
        button.layer.borderWidth = 0
        button.layer.borderColor = UIColor.darkG4.cgColor

        button.titleLabel?.font = .iosBody13B
        button.clipsToBounds = true
    }

    private lazy var cover: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.alpha = 0.7
        return blurView
    }()

    private var divider = UIView().then { view in
        view.backgroundColor = .darkG35
        view.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }

    private var coverLabel = UILabel().then { label in
        label.font = .iosBody15R
    }
}

extension AttendablePostCell {
    private func setup() {
        backgroundColor = .darkG55
        contentView.addSubviews([
            postInfoView,
            attendButton,
            divider,
            cover,
            coverLabel,
        ])
    }

    private func initialLayout() {
        layer.cornerRadius = 12
        clipsToBounds = true

        postInfoView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(18)
            make.leading.equalTo(contentView.snp.leading).offset(17)
            make.trailing.equalTo(contentView.snp.trailing).offset(-17)
            make.bottom.equalTo(contentView.snp.bottom).offset(-62)
        }

        attendButton.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.bottom).offset(-16)
            make.leading.equalTo(contentView.snp.leading).offset(17)
            make.trailing.equalTo(contentView.snp.trailing).offset(-17)
            make.height.equalTo(30)
        }
        attendButton.layer.cornerRadius = 15

        divider.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.bottom).offset(-42)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }

        cover.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
        }

        coverLabel.snp.makeConstraints { make in
            make.bottom.equalTo(cover.snp.bottom).offset(-10)
            make.centerX.equalTo(cover.snp.centerX)
        }
    }

    func update(with state: PostAttendState) {
        switch state {
        case .beforeAttendable:
            attendButton.isHidden = false
            divider.isHidden = true
            cover.isHidden = true
            coverLabel.isHidden = true

            attendButton.isEnabled = false
            attendButton.layer.borderWidth = 1
        case .attendable:
            attendButton.isHidden = false
            divider.isHidden = true
            cover.isHidden = true
            coverLabel.isHidden = true

            attendButton.isEnabled = true
            attendButton.layer.borderWidth = 0
        case .attend:
            attendButton.isHidden = true

            divider.isHidden = false
            cover.isHidden = false
            coverLabel.isHidden = false

            coverLabel.textColor = .primary
            coverLabel.text = L10n.MyPage.Main.Cell.Cover.Attend.yes
        case .absence:
            attendButton.isHidden = true

            divider.isHidden = false
            cover.isHidden = false
            coverLabel.isHidden = false

            coverLabel.textColor = .darkG2
            coverLabel.text = L10n.MyPage.Main.Cell.Cover.Attend.no
        }
    }

    private func updateAccessory(covered: Bool, attends: Bool) {
        if !covered {
            attendButton.isHidden = false

            divider.isHidden = true
            cover.isHidden = true
            coverLabel.isHidden = true

            if !attends {
                attendButton.isEnabled = false
                attendButton.layer.borderWidth = 1
            } else {
                attendButton.isEnabled = true
                attendButton.layer.borderWidth = 0
            }

        } else {
            attendButton.isHidden = true

            divider.isHidden = false
            cover.isHidden = false
            coverLabel.isHidden = false

            coverLabel.textColor = attends ? .primary : .darkG2
            coverLabel.text = attends ? L10n.MyPage.Main.Cell.Cover.Attend.yes : L10n.MyPage.Main.Cell.Cover.Attend.no
        }
    }
}

extension AttendablePostCell {
    static let id: String = "\(AttendablePostCell.self)"

    static let size: CGSize = {
        let hMargin: CGFloat = 12
        let width = UIScreen.main.bounds.width - hMargin * 2
        let height: CGFloat = 16 + BasicPostInfoView.height + 17 + 30 + 16
        return CGSize(width: width, height: height)
    }()
}
