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
        label.font = .iosBody13R
        label.textColor = .primary
        label.text = "ROLE"
    }

    var nameLabel = UILabel().then { label in
        label.font = .iosBody15B
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
            make.leading.equalTo(self.snp.leading)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
        }

        roleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(16)
            make.bottom.equalTo(imageView.snp.centerY).offset(-2)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(roleLabel.snp.leading)
            make.top.equalTo(imageView.snp.centerY).offset(2)
        }
    }
}
