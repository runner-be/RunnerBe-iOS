//
//  SelectContentView.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/21.
//

import RxCocoa
import RxSwift
import Then
import UIKit

class SelectTextContentView: SelectBaseView {
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

    var wordMax = 500

    private func processingInputs() {
        textField.rx.text
            .subscribe(onNext: { [weak self] text in
                guard let self = self,
                      let count = text?.count
                else { return }

                self.numberWordsLabel.text = "\(count)/500"
                if count >= self.wordMax {
                    self.numberWordsLabel.textColor = .errorlight
                } else {
                    self.numberWordsLabel.textColor = .darkG4
                }
            })
            .disposed(by: disposeBag)

        textField.rx.didBeginEditing
            .subscribe(onNext: { [weak self] in
                self?.placeHolder.isHidden = true
            })
            .disposed(by: disposeBag)

        textField.rx.didEndEditing
            .subscribe(onNext: { [weak self] in
                self?.placeHolder.isHidden = self?.textField.text.isEmpty == false
            })
            .disposed(by: disposeBag)
    }

    private var numberWordsLabel = UILabel().then { label in
        label.font = .iosBody15R
        label.textColor = .errorlight
        label.text = "0/500"
    }

    lazy var textField = UITextView().then { field in
        field.isEditable = true
        field.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 20, right: 16)
        field.backgroundColor = .darkG55
        field.font = .iosBody17R
        field.textColor = .darkG1
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.delegate = self
    }

    var placeHolder = UILabel().then { label in
        label.font = .iosBody17R
        label.textColor = .darkG35
        label.text = "함께할 러너들에게 하실 말씀이 있나요?"
    }

    override func setupViews() {
        super.setupViews()
        titleLabel.text = L10n.Post.Detail.TextContent.title

        addSubview(numberWordsLabel)

        contentView.addSubviews([
            textField,
            placeHolder,
        ])
    }

    override func initialLayout() {
        super.initialLayout()

        numberWordsLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.trailing.equalTo(self.snp.trailing)
        }

        textField.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(160)
            make.bottom.equalTo(contentView.snp.bottom).offset(-20)
        }
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 8

        placeHolder.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.top).offset(16)
            make.leading.equalTo(textField.snp.leading).offset(16)
            make.trailing.equalTo(textField.snp.trailing).offset(-16)
            make.bottom.lessThanOrEqualTo(textField.snp.bottom).offset(-20)
        }
    }
}

extension SelectTextContentView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= wordMax
    }
}
