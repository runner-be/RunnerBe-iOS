//
//  MakeDateView.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/19.
//

import RxCocoa
import RxSwift
import Then
import UIKit

class WritingDateView: SelectBaseView {
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
        group.icon = Asset.scheduled.uiImage
        group.titleLabel.text = L10n.Post.Date.placeHolder
        group.titleLabel.font = .iosBody15R
        group.titleLabel.textColor = .darkG1
    }

    override func setupViews() {
        super.setupViews()
        titleLabel.text = L10n.Post.Date.title

        addSubviews([
            groupBackground,
        ])

        groupBackground.addSubviews([
            iconTextButtonGroup,
        ])
    }

    override func initialLayout() {
        super.initialLayout()

        groupBackground.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(12)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
        }

        iconTextButtonGroup.snp.makeConstraints { make in
            make.top.equalTo(groupBackground.snp.top).offset(18)
            make.leading.equalTo(groupBackground.snp.leading).offset(16)
            make.trailing.equalTo(groupBackground.snp.trailing).offset(-16)
            make.bottom.equalTo(groupBackground.snp.bottom).offset(-18)
        }
    }
}
