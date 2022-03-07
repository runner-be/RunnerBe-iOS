//
//  UserInfoAcceptableCell.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/26.
//

import RxSwift
import SnapKit
import Then
import UIKit

final class UserInfoAcceptableCell: UICollectionViewCell {
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
        initialLayout()
    }

    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        disposeBag = DisposeBag()
        userInfoView.reset()
    }

    func setup(userInfo: UserConfig) {
        // TODO: avartarView
        userInfoView.setup(userInfo: userInfo)
    }

    private var userInfoView = UserInfoView()

    var acceptBtn = UIButton().then { button in
        button.setTitle(L10n.Home.PostDetail.Writer.yes, for: .normal)
        button.setTitleColor(.darkG6, for: .normal)
        button.setBackgroundColor(.primary, for: .normal)

        button.titleLabel?.font = .iosBody13B
        button.clipsToBounds = true
    }

    var refusalBtn = UIButton().then { button in
        button.setTitle(L10n.Home.PostDetail.Writer.no, for: .normal)
        button.setTitleColor(.darkG2, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.darkG2.cgColor
        button.titleLabel?.font = .iosBody13B
        button.clipsToBounds = true
    }

    private var hDivider = UIView().then { view in
        view.backgroundColor = .darkG5
    }

    private func setup() {
        contentView.addSubviews([
            userInfoView,
            acceptBtn,
            refusalBtn,
            hDivider,
        ])
    }

    private func initialLayout() {
        userInfoView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }

        refusalBtn.snp.makeConstraints { make in
            make.top.equalTo(userInfoView.snp.bottom).offset(20)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.centerX).offset(-6)
            make.height.equalTo(32)
        }
        refusalBtn.layer.cornerRadius = 16

        acceptBtn.snp.makeConstraints { make in
            make.top.equalTo(refusalBtn.snp.top)
            make.leading.equalTo(contentView.snp.centerX).offset(6)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(32)
        }
        acceptBtn.layer.cornerRadius = 16

        hDivider.snp.makeConstraints { make in
            make.top.equalTo(refusalBtn.snp.bottom).offset(20)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)

            make.height.equalTo(1)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
}

extension UserInfoAcceptableCell {
    static let id = "\(UserInfoAcceptableCell.self)"
}
