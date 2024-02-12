//
//  RunningPaceView.swift
//  Runner-be
//
//  Created by 이유리 on 2/12/24.
//

import SnapKit
import Then
import UIKit

final class RunningPaceView: UIView {
    init() {
        super.init(frame: .zero)
        setupViews()
        initialLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var label = UILabel().then { view in
        view.font = .pretendardRegular14
        view.textColor = .darkG1
    }
}

extension RunningPaceView {
    func setupViews() {
        layer.cornerRadius = 4
        layer.masksToBounds = true
        backgroundColor = .darkG45

        addSubviews([
            label,
        ])
    }

    func initialLayout() {
        label.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(4)
            make.bottom.equalTo(self.snp.bottom).offset(-4)
            make.leading.equalTo(self.snp.leading).offset(8)
            make.trailing.equalTo(self.snp.trailing).offset(-8)
        }
    }
}
