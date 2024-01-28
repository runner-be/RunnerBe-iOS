//
//  SelectionLabel.swift
//  Runner-be
//
//  Created by 김신우 on 2022/05/08.
//

import SnapKit
import UIKit

class SelectionLabel: UIView {
    var label = UILabel()
    var icon = UIImageView()
    var iconSize: CGSize = .zero {
        didSet {
            setConstraints()
        }
    }

    init(iconSize: CGSize = .zero) {
        self.iconSize = iconSize
        super.init(frame: .zero)

        addSubviews([label, icon])

        setConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setConstraints() {
        icon.snp.removeConstraints()

        icon.snp.makeConstraints { make in
            make.width.equalTo(iconSize.width)
            make.height.equalTo(iconSize.height)
        }
    }
}
