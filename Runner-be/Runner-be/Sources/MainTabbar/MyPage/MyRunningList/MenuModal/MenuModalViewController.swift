//
//  MenuModalViewController.swift
//  Runner-be
//
//  Created by 김창규 on 9/6/24.
//

import UIKit

final class MenuModalViewController: BaseViewController {
    // MARK: - Properties

    private let viewModel: MenuModalViewModel

    // MARK: - UI

    private let backgroundView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.6)
    }

    private let sheet = UIView().then {
        $0.backgroundColor = .darkG5
        $0.layer.cornerRadius = 14
    }

    private let editButton = UIButton().then {
        $0.setTitle("수정", for: .normal)
        $0.setTitleColor(.primary, for: .normal)
        $0.titleLabel?.font = .pretendardRegular16
        $0.backgroundColor = .clear
    }

    private let divider = UIView().then {
        $0.backgroundColor = .darkG45
    }

    private let deleteButton = UIButton().then {
        $0.setTitle("삭제", for: .normal)
        $0.setTitleColor(.primary, for: .normal)
        $0.titleLabel?.font = .pretendardRegular16
        $0.backgroundColor = .clear
    }

    // MARK: - Init

    init(viewModel: MenuModalViewModel) {
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
            .bind(to: viewModel.inputs.tapBackground)
            .disposed(by: disposeBag)

        editButton.rx.tap
            .bind(to: viewModel.inputs.tapEdit)
            .disposed(by: disposeBag)

        deleteButton.rx.tap
            .bind(to: viewModel.inputs.tapDelete)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {}
}

// MARK: - Layout

extension MenuModalViewController {
    private func setupViews() {
        view.addSubviews([
            backgroundView,
            sheet,
        ])

        sheet.addSubviews([
            editButton,
            divider,
            deleteButton,
        ])
    }

    private func initialLayout() {
        backgroundView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }

        sheet.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(100)
            $0.width.equalTo(270)
        }

        editButton.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.width.equalTo(270)
            $0.height.equalTo(50)
        }

        divider.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(1)
        }

        deleteButton.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.width.equalTo(270)
            $0.height.equalTo(50)
        }
    }
}
