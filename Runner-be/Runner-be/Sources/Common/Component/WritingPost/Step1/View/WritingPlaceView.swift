//
//  WritingPlaceView.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/19.
//

import RxCocoa
import RxSwift
import Then
import UIKit

class WritingPlaceView: SelectBaseView {
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

    // TODO: rx.으로 빼기
    var contentText: Binder<String?> {
        iconTextButtonGroup.titleLabel.rx.text
    }

    private var groupBackground = UIView().then { view in
        view.backgroundColor = .darkG55
        view.clipsToBounds = true
        view.layer.cornerRadius = 6
    }

    var iconTextButtonGroup = IconTextButtonGroup().then { group in
        group.icon = Asset.place.uiImage
        group.titleLabel.text = L10n.Post.Place.placeHolder
        group.titleLabel.font = .pretendardRegular16
        group.titleLabel.textColor = .darkG1
        group.moreInfoButton.isEnabled = false
        group.titleLabel.layer.opacity = 1.0
    }

    let setCityLabel = UILabel().then {
        $0.textColor = .darkG1
        $0.font = .pretendardRegular16
    }

    let setDetailLabel = UILabel().then {
        $0.textColor = .darkG35
        $0.font = .pretendardRegular14
    }

    private lazy var vStackView = UIStackView.make(
        with: [groupBackground],
        axis: .vertical,
        alignment: .fill,
        distribution: .equalSpacing,
        spacing: 8
    )

    override func setupViews() {
        super.setupViews()
        titleLabel.text = L10n.Home.Filter.Place.title

        addSubviews([
            vStackView,
        ])

        groupBackground.addSubviews([
            iconTextButtonGroup,
            setCityLabel,
            setDetailLabel,
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
            make.bottom.equalTo(groupBackground.snp.bottom).offset(-18).priority(.required)
        }

        setCityLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(19)
            $0.left.equalToSuperview().offset(47)
        }

        setDetailLabel.snp.makeConstraints {
            $0.top.equalTo(setCityLabel.snp.bottom).offset(4)
            $0.left.equalTo(setCityLabel)
            $0.right.equalTo(iconTextButtonGroup.moreInfoButton.snp.left).offset(-8)
            $0.bottom.equalTo(groupBackground.snp.bottom).offset(-18).priority(.high)
        }
    }
}
