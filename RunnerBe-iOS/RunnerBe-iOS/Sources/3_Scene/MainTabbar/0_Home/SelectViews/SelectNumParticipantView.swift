//
//  SelectNumParticipantView.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/21.
//

import RxCocoa
import RxSwift
import Then
import UIKit

class SelectNumParticipantView: SelectBaseView {
    init() {
        super.init(frame: .zero)
        setupViews()
        initialLayout()
        processingInputs()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func processingInputs() {}

    var numberLabel = UILabel().then { label in
        label.font = .iosBody17Sb
        label.textColor = .primary
        label.text = "2"
    }

    private var minusBtn = UIButton().then { button in
        button.setImage(Asset.minus.uiImage.withTintColor(.darkG35), for: .normal)
        button.setImage(Asset.minus.uiImage.withTintColor(.darkG55), for: .disabled)
    }

    private var plusBtn = UIButton().then { button in
        button.setImage(Asset.plus.uiImage.withTintColor(.darkG35), for: .normal)
        button.setImage(Asset.plus.uiImage.withTintColor(.darkG55), for: .disabled)
    }

    private lazy var hStackView = UIStackView.make(
        with: [minusBtn, numberLabel, plusBtn],
        axis: .horizontal,
        alignment: .center,
        distribution: .equalSpacing,
        spacing: 32
    )

    private var errorLabel = UILabel().then { label in
        label.font = .iosBody13R
        label.textColor = .errorlight
        label.text = L10n.Post.Detail.NumParticipant.mixError
        label.isHidden = true
    }

    private lazy var vStackView = UIStackView.make(
        with: [hStackView, errorLabel],
        axis: .vertical,
        alignment: .center,
        distribution: .equalSpacing,
        spacing: 20
    )

    override func setupViews() {
        super.setupViews()
        titleLabel.text = L10n.Post.Detail.NumParticipant.title

        contentView.addSubviews([
            vStackView,
        ])
    }

    override func initialLayout() {
        super.initialLayout()

        vStackView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.centerX.equalTo(contentView.snp.centerX)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
}
