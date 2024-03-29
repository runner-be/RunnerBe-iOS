//
//  SignoutCompletionModalViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/06.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class SignoutCompletionModalViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: SignoutCompletionModalViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: SignoutCompletionModalViewModel

    private func viewModelInput() {
        sheet.rx.tapGesture(configuration: { _, delegate in
            delegate.simultaneousRecognitionPolicy = .never
        })
        .when(.recognized)
        .subscribe()
        .disposed(by: disposeBag)

        view.rx.tapGesture(configuration: { _, delegate in
            delegate.simultaneousRecognitionPolicy = .never
        })
        .when(.recognized)
        .map { _ in }
        .subscribe(viewModel.inputs.move)
        .disposed(by: disposeBag)

        buttonOk.rx.tap
            .bind(to: viewModel.inputs.move)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)
    }

    private var sheet = UIView().then { view in
        view.backgroundColor = .darkG5
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
    }

    private var titleLabel = UILabel().then { label in
        label.font = .iosBody17R
        label.textColor = .darkG1
        label.text = L10n.MyPage.Settings.Modal.SignoutCompletion.message
        label.numberOfLines = 2
        label.textAlignment = .center
    }

    private var hDivider = UIView().then { view in
        view.backgroundColor = .darkG45
    }

    private var buttonOk = UIButton().then { button in
        button.setTitle(L10n.MyPage.Settings.Modal.SignoutCompletion.ok, for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)

        button.titleLabel?.font = .iosBody17R

        button.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
}

// MARK: - Layout

extension SignoutCompletionModalViewController {
    private func setupViews() {
        view.backgroundColor = .bgSheet

        view.addSubviews([
            sheet,
        ])

        sheet.addSubviews([
            titleLabel,
            hDivider,
            buttonOk,
        ])
    }

    private func initialLayout() {
        sheet.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
            make.leading.equalTo(52)
            make.trailing.equalTo(-52)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(sheet.snp.top).offset(24)
            make.leading.equalTo(sheet.snp.leading).offset(24)
            make.trailing.equalTo(sheet.snp.trailing).offset(-24)
        }

        hDivider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(23)
            make.leading.equalTo(sheet.snp.leading)
            make.trailing.equalTo(sheet.snp.trailing)
            make.height.equalTo(1)
        }

        buttonOk.snp.makeConstraints { make in
            make.top.equalTo(hDivider.snp.bottom)
            make.leading.equalTo(sheet.snp.leading)
            make.trailing.equalTo(sheet.snp.trailing)
            make.bottom.equalTo(sheet.snp.bottom)
        }
    }
}
