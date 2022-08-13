//
//  ManageAttendanceButtonGroup.swift
//  Runner-be
//
//  Created by 이유리 on 2022/08/13.
//

import SnapKit
import Then
import UIKit

final class ManageAttendanceButtonGroup: UIView {
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero)
        setup()
        initialLayout()
    }

    private var attendantButton = UIButton().then { view in
        view.titleLabel?.text = L10n.MyPage.MyPost.Manage.Attend.title
    }

    private var absenceButton = UIButton().then { view in
        view.titleLabel?.text = L10n.MyPage.MyPost.Manage.Absent.title
    }

    private func setup() {
        addSubviews([
            attendantButton,
            absenceButton,
        ])
    }

    private func initialLayout() {
//        attendantButton.snp.makeConstraints{ make in
//            make.top.equalTo(self..snp.top)
//            make.leading.equalTo(self.view.snp.leading)
//            make.bottom.equalTo(self.view.snp.bottom)
//        }

//        absenceButton.snp.makeConstraints{ make in
//
//        }
    }
}
