//
//  PostDetailFooter.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/26.
//

import RxSwift
import Then
import UIKit

class PostDetailFooter: UIView {
    var disposeBag = DisposeBag()

    func setup() {
        backgroundColor = .darkG6
        addSubviews([toMessageButton, applyBtn])
    }

    func initialLayout() {
        snp.makeConstraints { make in
            make.height.equalTo(56)
        }

        toMessageButton.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(16)
            make.centerY.equalTo(self.snp.centerY)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }

        applyBtn.snp.makeConstraints { make in
            make.leading.equalTo(toMessageButton.snp.trailing).offset(12)
            make.trailing.equalTo(self.snp.trailing).offset(-16)
            make.centerY.equalTo(self.snp.centerY)
            make.height.equalTo(40)
        }
    }

    override func removeFromSuperview() {
        disposeBag = DisposeBag()
        super.removeFromSuperview()
    }

    var toMessageButton = UIButton().then { button in
        button.setImage(Asset.messageActive.uiImage, for: .normal)
        button.setImage(Asset.messageInactive.uiImage, for: .disabled)
    }

    var applyBtn = UIButton().then { button in
//        button.setTitle(L10n.Home.PostDetail.Guest.apply, for: .normal)
        button.setTitleColor(UIColor.darkBlack, for: .normal)
        button.setBackgroundColor(UIColor.primary, for: .normal)
//        button.setTitle(L10n.Home.PostDetail.Guest.applied, for: .disabled)
        button.setTitleColor(UIColor.darkG45, for: .disabled)
        button.setBackgroundColor(UIColor.darkG3, for: .disabled)

        button.titleLabel?.font = .iosBody15B
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
    }
}

class PostGuestFooter: PostDetailFooter {
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(applied: Bool, satisfied: Bool) {
        super.init(frame: .zero)
        setup(applied: applied, satisfied: satisfied)
        initialLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyBtn.layer.cornerRadius = applyBtn.frame.height / 2.0
    }

    private func setup(applied: Bool, satisfied: Bool) {
        super.setup()

        applyBtn.setTitle(L10n.Home.PostDetail.Guest.apply, for: .normal)
        applyBtn.setTitle(L10n.Home.PostDetail.Guest.applied, for: .disabled)
        if applied {
            applyBtn.setTitle(L10n.Home.PostDetail.Guest.applied, for: .disabled)
            applyBtn.isEnabled = false
        } else if !satisfied {
            applyBtn.setTitle(L10n.Home.PostDetail.Guest.notSatisfied, for: .disabled)
            applyBtn.isEnabled = false
        } else {
            applyBtn.isEnabled = true
            applyBtn.setTitle(L10n.Home.PostDetail.Guest.apply, for: .normal)
        }
    }
}

class PostWriterFooter: PostDetailFooter {
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero)
        setup()
        initialLayout()
    }

    override func setup() {
        super.setup()
        applyBtn.setTitle(L10n.Home.PostDetail.Writer.finishing, for: .normal)
        applyBtn.setTitle(L10n.Home.PostDetail.Writer.finished, for: .disabled)
        toMessageButton.isEnabled = true
    }
}
