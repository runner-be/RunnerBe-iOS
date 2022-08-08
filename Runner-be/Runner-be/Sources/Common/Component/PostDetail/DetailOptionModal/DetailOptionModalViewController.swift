//
//  DetailOptionModalModalViewController.swift
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

class DetailOptionModalViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: DetailOptionModalViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: DetailOptionModalViewModel

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
        .subscribe(viewModel.inputs.backward)
        .disposed(by: disposeBag)

        deletePostButton.rx.tap
            .bind(to: viewModel.inputs.tapDelete)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {}

    private var sheet = UIView().then { view in
        view.backgroundColor = .darkG5
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
    }

    private var deletePostButton = UIButton().then { button in
        button.setTitle("삭제하기", for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)
        button.titleLabel?.font = .iosBody17R
    }
}

// MARK: - Layout

extension DetailOptionModalViewController {
    private func setupViews() {
        view.backgroundColor = .bgSheet

        view.addSubviews([
            sheet,
        ])

        sheet.addSubviews([
            deletePostButton,
        ])
    }

    private func initialLayout() {
        sheet.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.width.equalTo(view.snp.width).offset(-100)
        }

        deletePostButton.snp.makeConstraints { make in
            make.top.equalTo(sheet.snp.top)
            make.leading.equalTo(sheet.snp.leading)
            make.trailing.equalTo(sheet.snp.trailing)
            make.bottom.equalTo(sheet.snp.bottom)
            make.height.equalTo(52)
        }
    }
}
