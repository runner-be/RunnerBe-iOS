//
//  ManageAttendanceResultView.swift
//  Runner-be
//
//  Created by 이유리 on 2022/08/13.
//

import SnapKit
import Then
import UIKit

final class ManageAttendanceResultView: UIView {
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero)
        setup()
        initialLayout()
    }

    private var background = UIView().then { view in
        view.backgroundColor = .darkG6
    }

    private var label = UIButton().then { view in
        view.titleLabel?.text = L10n.MyPage.MyPost.Manage.Absent.title
    }

    private func setup() {
        addSubviews([
            background,
            label,
        ])
    }

    private func initialLayout() {
        background.snp.makeConstraints { _ in
//            make.top.equalTo(self.view.snp.top).offset(24)
//            make.leading.equalTo(contentView.snp.leading).offset(16)
//            make.trailing.equalTo(self.view.snp.trailing).offset(-16)
//            make.bottom.equalTo(self.view.snp.bottom)
        }

        label.snp.makeConstraints { _ in
        }
    }
}
