//
//  ConfirmAttendanceCell.swift
//  Runner-be
//
//  Created by 김창규 on 9/1/24.
//

import UIKit

final class ConfirmAttendanceCell: UITableViewCell {
    // MARK: - Properties

    static let id: String = "\(ConfirmAttendanceCell.self)"

    // MARK: - UI

    var userInfoView = UserInfoView()

    var divider = UIView().then {
        $0.backgroundColor = .darkG6
    }

    var resultLabel = UILabel().then {
        $0.font = .pretendardRegular14
        $0.textAlignment = .center
    }

    private let spacingView = UIView().then {
        $0.backgroundColor = .black
    }

    // MARK: - Init

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews() // cell 세팅
        initialLayout() // cell 레이아웃 설정
        contentView.isUserInteractionEnabled = true
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func configure(status: Int) { // FIXME: 임시
        switch status {
        case 1:
            resultLabel.text = "출석을 완료 했어요"
            resultLabel.textColor = .primary
        case 2:
            resultLabel.text = "출석을 체크하지 않았어요"
            resultLabel.textColor = .darkG35
        case 3:
            resultLabel.text = "불참했어요"
            resultLabel.textColor = .darkG35
        default:
            return
        }
    }
}

// MARK: - Layout

extension ConfirmAttendanceCell {
    private func setupViews() {
        contentView.backgroundColor = .darkG7
        contentView.addSubviews([
            userInfoView,
            divider,
            resultLabel,
            spacingView,
        ])
    }

    private func initialLayout() {
        userInfoView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(16)
        }

        divider.snp.makeConstraints {
            $0.top.equalTo(userInfoView.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }

        resultLabel.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
        }

        spacingView.snp.makeConstraints {
            $0.top.equalTo(resultLabel.snp.bottom).offset(16)
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(12)
        }
    }
}
