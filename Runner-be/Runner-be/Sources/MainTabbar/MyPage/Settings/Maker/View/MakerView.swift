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

    var labelContainerView = UIView()

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
            labelContainerView,
        ])

        labelContainerView.addSubviews([
            roleLabel,
            nameLabel,
        ])
    }

    func initialLayout() {
        imageView.snp.makeConstraints { make in
            make.width.equalTo(83)
            make.height.equalTo(96)
            make.centerX.equalToSuperview()
            make.leading.equalTo(self.snp.leading)
            make.top.equalTo(self.snp.top)
        }

        labelContainerView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(4)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }

        roleLabel.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview()
        }

        nameLabel.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
            $0.left.equalTo(roleLabel.snp.right).offset(6)
        }
    }
}
