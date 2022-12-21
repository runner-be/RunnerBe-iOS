//
//  MakerView.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import RxCocoa
import RxSwift
import Then
import UIKit

class MakerView: UIView {
    init() {
        super.init(frame: .zero)
        setupViews()
        initialLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var disposeBag = DisposeBag()

    var imageView = UIImageView().then { view in
        view.image = Asset.profileEmptyIcon.uiImage
        view.contentMode = .scaleAspectFit
    }

    var roleLabel = UILabel().then { label in
        label.font = .iosBody13B
        label.textColor = .primary
        label.text = "ROLE"
    }

    var nameLabel = UILabel().then { label in
        label.font = .iosBody13R
        label.textColor = .darkG1
        label.text = "NAME"
    }

    func setupViews() {
        addSubviews([
            imageView,
            roleLabel,
            nameLabel,
        ])
    }

    func initialLayout() {
        imageView.snp.makeConstraints { make in
            make.width.equalTo(85)
            make.height.equalTo(90)
            make.leading.equalTo(self.snp.leading)
            make.top.equalTo(self.snp.top)
        }

        roleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.leading).offset(10)
            make.top.equalTo(imageView.snp.bottom).offset(5)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(roleLabel.snp.trailing).offset(6)
            make.centerY.equalTo(roleLabel.snp.centerY)
        }
    }
}
