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

    func initialLayout() {
        snp.makeConstraints { make in
            make.height.equalTo(56)
        }
    }

    override func removeFromSuperview() {
        disposeBag = DisposeBag()
        super.removeFromSuperview()
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

    var bookMarkBtn = UIButton().then { button in
        button.setImage(Asset.bigBookmarkNormal.uiImage, for: .normal)
        button.setImage(Asset.bigBookmarkSelected.uiImage, for: .selected)
    }

    var applyBtn = UIButton().then { button in
        button.setTitle(L10n.Home.PostDetail.Guest.apply, for: .normal)
        button.setTitleColor(UIColor.darkBlack, for: .normal)
        button.setBackgroundColor(UIColor.primary, for: .normal)
        button.setTitle(L10n.Home.PostDetail.Guest.applied, for: .disabled)
        button.setTitleColor(UIColor.darkG45, for: .disabled)
        button.setBackgroundColor(UIColor.darkG3, for: .disabled)

        button.titleLabel?.font = .iosBody15B

        button.clipsToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        applyBtn.layer.cornerRadius = applyBtn.frame.height / 2.0
    }

    private func setup(applied: Bool, satisfied: Bool) {
        backgroundColor = .darkG6
        addSubviews([bookMarkBtn, applyBtn])

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

    override func initialLayout() {
        super.initialLayout()

        bookMarkBtn.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(16)
            make.top.equalTo(self.snp.top).offset(8)
            make.bottom.equalTo(self.snp.bottom).offset(-8)
            make.width.equalTo(bookMarkBtn.snp.height)
        }

        applyBtn.snp.makeConstraints { make in
            make.leading.equalTo(bookMarkBtn.snp.trailing).offset(12)
            make.trailing.equalTo(self.snp.trailing).offset(-16)
            make.top.equalTo(self.snp.top).offset(8)
            make.bottom.equalTo(self.snp.bottom).offset(-8)
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

    var finishingBtn = UIButton().then { button in
        button.setTitle(L10n.Home.PostDetail.Writer.finishing, for: .normal)
        button.setTitleColor(UIColor.darkBlack, for: .normal)
        button.setBackgroundColor(UIColor.primary, for: .normal)
        button.setTitle(L10n.Home.PostDetail.Writer.finished, for: .disabled)
        button.setTitleColor(UIColor.darkG45, for: .disabled)
        button.setBackgroundColor(UIColor.darkG3, for: .disabled)
        button.titleLabel?.font = .iosBody15B

        button.clipsToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        finishingBtn.layer.cornerRadius = finishingBtn.frame.height / 2.0
    }

    private func setup() {
        backgroundColor = .darkG6
        addSubviews([finishingBtn])
    }

    override func initialLayout() {
        super.initialLayout()

        finishingBtn.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(16)
            make.trailing.equalTo(self.snp.trailing).offset(-16)
            make.top.equalTo(self.snp.top).offset(8)
            make.bottom.equalTo(self.snp.bottom).offset(-8)
        }
    }
}
