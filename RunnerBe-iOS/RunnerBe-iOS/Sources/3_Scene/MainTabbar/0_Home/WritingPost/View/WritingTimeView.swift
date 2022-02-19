//
//  WritingTimeView.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/19.
//

import RxCocoa
import RxSwift
import Then
import UIKit

class WritingTimeView: FilterBaseView {
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

    private var groupBackground = UIView().then { view in
        view.backgroundColor = .darkG55
        view.clipsToBounds = true
        view.layer.cornerRadius = 6
    }

    private var iconTextButtonGroup = IconTextButtonGroup().then { group in
        group.icon = Asset.time.uiImage
        group.titleLabel.text = L10n.Post.Time.placeHolder
        group.titleLabel.font = .iosBody15R
        group.titleLabel.textColor = .darkG1
    }

    private var errorLabel = UILabel().then { label in
        label.font = .iosBody13R
        label.textColor = .errorlight
        label.text = L10n.Post.Time.error
        label.isHidden = false
    }

    private lazy var vStackView = UIStackView.make(
        with: [groupBackground, errorLabel],
        axis: .vertical,
        alignment: .fill,
        distribution: .equalSpacing,
        spacing: 8
    )

    override func setupViews() {
        super.setupViews()
        titleLabel.text = L10n.Post.Time.title

        addSubviews([
            vStackView,
        ])

        groupBackground.addSubviews([
            iconTextButtonGroup,
        ])
    }

    override func initialLayout() {
        super.initialLayout()

        vStackView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(12)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom).offset(-3)
        }

        iconTextButtonGroup.snp.makeConstraints { make in
            make.top.equalTo(groupBackground.snp.top).offset(18)
            make.leading.equalTo(groupBackground.snp.leading).offset(16)
            make.trailing.equalTo(groupBackground.snp.trailing).offset(-16)
            make.bottom.equalTo(groupBackground.snp.bottom).offset(-18)
        }
    }
}
