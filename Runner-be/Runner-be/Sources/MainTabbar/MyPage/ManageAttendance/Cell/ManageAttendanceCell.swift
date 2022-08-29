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
    }

    var userInfoView = UserInfoView()

    var resultView = ManageAttendanceResultView()
    
//    var manageButtonGroup = OnOffLabelGroup().then { view in
//        view.labels = [OnOffLabel(text: "결석"), OnOffLabel(text: "출석")]
//    }

//    var buttonGroup =

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
