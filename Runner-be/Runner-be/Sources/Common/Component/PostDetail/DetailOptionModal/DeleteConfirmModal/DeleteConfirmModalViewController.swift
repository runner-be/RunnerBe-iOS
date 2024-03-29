//
//  DeleteConfirmModalViewController.swift
//  Runner-be
//
//  Created by 김신우 on 2022/08/08.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class DeleteConfirmModalViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: DeleteConfirmModalViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: DeleteConfirmModalViewModel

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
        .subscribe(viewModel.inputs.cancel)
        .disposed(by: disposeBag)

        buttonOk.rx.tap
            .bind(to: viewModel.inputs.ok)
            .disposed(by: disposeBag)

        buttonNo.rx.tap
            .bind(to: viewModel.inputs.cancel)
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
        label.text = "글을 삭제할 수 있어요.\n삭제하시겠어요?"
        label.numberOfLines = 2
        label.textAlignment = .center
    }

    private var hDivider = UIView().then { view in
        view.backgroundColor = .darkG45
    }

    private var buttonOk = UIButton().then { button in
        button.setTitle("네", for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)

        button.titleLabel?.font = .iosBody17R
    }

    private var vDivider = UIView().then { view in
        view.backgroundColor = .darkG45
    }

    private var buttonNo = UIButton().then { button in
        button.setTitle("아니오", for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)

        button.titleLabel?.font = .iosBody17R
    }
}

// MARK: - Layout

extension DeleteConfirmModalViewController {
    private func setupViews() {
        view.backgroundColor = .bgSheet

        view.addSubviews([
            sheet,
        ])

        sheet.addSubviews([
            titleLabel,
            hDivider,
            buttonOk,
            vDivider,
            buttonNo,
        ])
    }

    private func initialLayout() {
        sheet.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.width.equalTo(270)
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

        vDivider.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(50)
            make.centerX.equalTo(sheet.snp.centerX)
            make.top.equalTo(hDivider.snp.bottom)
            make.bottom.equalTo(sheet.snp.bottom)
        }

        buttonNo.snp.makeConstraints { make in
            make.top.equalTo(vDivider.snp.top)
            make.leading.equalTo(sheet.snp.leading)
            make.trailing.equalTo(vDivider.snp.leading)
            make.bottom.equalTo(vDivider.snp.bottom)
        }

        buttonOk.snp.makeConstraints { make in
            make.top.equalTo(vDivider.snp.top)
            make.leading.equalTo(vDivider.snp.trailing)
            make.trailing.equalTo(sheet.snp.trailing)
            make.bottom.equalTo(vDivider.snp.bottom)
        }
    }
}
