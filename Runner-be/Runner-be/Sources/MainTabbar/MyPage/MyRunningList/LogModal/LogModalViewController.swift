//
//  LogModalViewController.swift
//  Runner-be
//
//  Created by 김창규 on 9/6/24.
//

import Foundation

import UIKit

final class LogModalViewController: BaseViewController {
    // MARK: - Properties

    private let viewModel: LogModalViewModel

    // MARK: - UI

    private let backgroundView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.6)
    }

    private let sheet = UIView().then {
        $0.backgroundColor = .darkG5
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
    }

    private let titleLabel = UILabel().then {
        $0.font = .iosBody17R
        $0.textColor = .darkG1
        $0.text = "저장해야 로그가 기록돼요.\n 정말 나가시겠어요?"
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }

    private let hDivider = UIView().then {
        $0.backgroundColor = .darkG45
    }

    private let buttonOk = UIButton().then {
        $0.setTitle("네", for: .normal)
        $0.setTitleColor(.primary, for: .normal)
        $0.setBackgroundColor(.clear, for: .normal)
        $0.titleLabel?.font = .iosBody17R
    }

    private let vDivider = UIView().then {
        $0.backgroundColor = .darkG45
    }

    private let buttonNo = UIButton().then {
        $0.setTitle(L10n.Home.PostDetail.Report.Button.no, for: .normal)
        $0.setTitleColor(.primary, for: .normal)
        $0.setBackgroundColor(.clear, for: .normal)
        $0.titleLabel?.font = .iosBody17R
    }

    // MARK: - Init

    init(viewModel: LogModalViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    // MARK: - Methods

    private func viewModelInput() {
        backgroundView.rx.tapGesture()
            .when(.recognized)
            .map { _ in }
            .bind(to: viewModel.routes.backward)
            .disposed(by: disposeBag)

        buttonOk.rx.tap
            .bind(to: viewModel.routes.tapOK)
            .disposed(by: disposeBag)

        buttonNo.rx.tap
            .bind(to: viewModel.routes.backward)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {}
}

// MARK: - Layout

extension LogModalViewController {
    private func setupViews() {
        view.addSubviews([
            backgroundView,
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
        backgroundView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }

        sheet.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(270)
        }

        titleLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(24)
        }

        hDivider.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(23)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }

        vDivider.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(50)
            $0.top.equalTo(hDivider.snp.bottom)
            $0.bottom.centerX.equalToSuperview()
        }

        buttonNo.snp.makeConstraints {
            $0.top.equalTo(vDivider.snp.top)
            $0.left.equalTo(sheet.snp.left)
            $0.right.equalTo(vDivider.snp.left)
            $0.bottom.equalTo(vDivider.snp.bottom)
        }

        buttonOk.snp.makeConstraints {
            $0.top.equalTo(vDivider.snp.top)
            $0.left.equalTo(vDivider.snp.right)
            $0.right.equalTo(sheet.snp.right)
            $0.bottom.equalTo(vDivider.snp.bottom)
        }
    }
}
