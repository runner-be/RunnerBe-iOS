//
//  EmailCertificationInitModalViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class SelectDateModalViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: SelectDateModalViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: SelectDateModalViewModel

    private func viewModelInput() {
        buttonOk.rx.tap
            .bind(to: viewModel.inputs.tapOK)
            .disposed(by: disposeBags)
    }

    private func viewModelOutput() {}

    private var sheet = UIView().then { view in
        view.backgroundColor = .darkG5
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
    }

    private var titleLabel1 = UILabel().then { label in
        label.font = .iosBody17R
        label.textColor = .darkG1
        label.text = L10n.EmailCertification.Modal.Message._1
        label.textAlignment = .center
    }

    private var titleLabel2 = UILabel().then { label in
        label.font = .iosBody17R
        label.textColor = .darkG1
        label.text = L10n.EmailCertification.Modal.Message._2
        label.textAlignment = .center
    }

    private var hDivider = UIView().then { view in
        view.backgroundColor = .darkG45
    }

    private var buttonOk = UIButton().then { button in
        button.setTitle(L10n.EmailCertification.Modal.Button.yes, for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)

        button.titleLabel?.font = .iosBody17R
    }
}

// MARK: - Layout

extension SelectDateModalViewController {
    private func setupViews() {
        view.backgroundColor = .bgSheet

        view.addSubviews([
            sheet,
        ])

        sheet.addSubviews([
            titleLabel1,
            titleLabel2,
            hDivider,
            buttonOk,
        ])
    }

    private func initialLayout() {
        sheet.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.width.equalTo(270)
        }

        titleLabel1.snp.makeConstraints { make in
            make.top.equalTo(sheet.snp.top).offset(24)
            make.leading.equalTo(sheet.snp.leading).offset(24)
            make.trailing.equalTo(sheet.snp.trailing).offset(-24)
        }

        titleLabel2.snp.makeConstraints { make in
            make.top.equalTo(titleLabel1.snp.bottom).offset(2)
            make.leading.equalTo(sheet.snp.leading).offset(24)
            make.trailing.equalTo(sheet.snp.trailing).offset(-24)
        }

        hDivider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel2.snp.bottom).offset(23)
            make.leading.equalTo(sheet.snp.leading)
            make.trailing.equalTo(sheet.snp.trailing)
            make.height.equalTo(1)
        }

        buttonOk.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(hDivider.snp.bottom)
            make.leading.equalTo(sheet.snp.leading)
            make.trailing.equalTo(sheet.snp.trailing)
            make.bottom.equalTo(sheet.snp.bottom)
        }
    }
}
