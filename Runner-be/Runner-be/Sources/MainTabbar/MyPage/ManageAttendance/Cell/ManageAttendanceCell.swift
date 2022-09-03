//
//  ManageAttendanceCell.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/24.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class ManageAttendanceCell: UITableViewCell {
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
        contentView.isUserInteractionEnabled = true
    }

    var userInfoView = UserInfoView()

    var resultView = ManageAttendanceResultView()

    var refusalBtn = UIButton().then { button in
        button.setTitle(L10n.MyPage.MyPost.Manage.Absent.title, for: .normal)
        button.setTitleColor(.darkG3, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)
        button.titleLabel?.font = .iosBody15R

        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.darkG4.cgColor
        button.clipsToBounds = true
    }

    var acceptBtn = UIButton().then { button in
        button.setTitle(L10n.MyPage.MyPost.Manage.Attend.title, for: .normal)
        button.setTitleColor(.darkG3, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)
        button.titleLabel?.font = .iosBody15R

        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.darkG4.cgColor
        button.clipsToBounds = true
    }

    var dividerView = UIView().then { view in
        view.backgroundColor = .black
    }

    func configure(userInfo: UserConfig) {
        // TODO: avartarView
        userInfoView.setup(userInfo: userInfo)
    }
}

extension ManageAttendanceCell {
    private func setup() {
        backgroundColor = .darkG7
        contentView.addSubviews([
            userInfoView,
            resultView,
            acceptBtn,
            refusalBtn,
            dividerView,
        ])
    }

    private func initialLayout() {
        userInfoView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing)
            make.top.equalTo(contentView.snp.top).offset(24)
        }

        resultView.snp.makeConstraints { make in
            make.top.equalTo(userInfoView.snp.bottom).offset(20)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }

        refusalBtn.snp.makeConstraints { make in
            make.top.equalTo(userInfoView.snp.bottom).offset(20)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.centerX)
            make.height.equalTo(32)
        }
        refusalBtn.layer.cornerRadius = 16

        acceptBtn.snp.makeConstraints { make in
            make.top.equalTo(refusalBtn.snp.top)
            make.leading.equalTo(contentView.snp.centerX).offset(11)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.height.equalTo(32)
        }
        acceptBtn.layer.cornerRadius = 16

        dividerView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.top.equalTo(resultView.snp.bottom).offset(26)
            make.height.equalTo(14)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
}

extension ManageAttendanceCell {
    static let id: String = "\(ManageAttendanceCell.self)"
}
