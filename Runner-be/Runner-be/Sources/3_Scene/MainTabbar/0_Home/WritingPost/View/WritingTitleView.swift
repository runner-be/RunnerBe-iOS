//
//  WritingTitleView.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/19.
//

import RxCocoa
import RxSwift
import Then
import UIKit

class WritingTitleView: SelectBaseView {
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

    var textField = TextFieldWithPadding().then { field in
        field.textPadding = UIEdgeInsets(top: 18, left: 16, bottom: 18, right: 16)
        field.backgroundColor = .darkG55
        field.font = .iosBody15R
        field.textAlignment = .left
        field.textColor = .darkG2
        field.attributedPlaceholder = NSAttributedString(
            string: L10n.Post.Title.placeHolder,
            attributes: [.foregroundColor: UIColor.darkG35]
        )
        field.autocapitalizationType = .none
        field.autocorrectionType = .no

        field.clipsToBounds = true
        field.layer.cornerRadius = 6

        field.layer.borderColor = UIColor.primary.cgColor
    }

    override func setupViews() {
        super.setupViews()
        titleLabel.text = L10n.Post.Title.title

        addSubviews([
            textField,
        ])
    }

    override func initialLayout() {
        super.initialLayout()

        textField.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(12)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
        }
    }
}
