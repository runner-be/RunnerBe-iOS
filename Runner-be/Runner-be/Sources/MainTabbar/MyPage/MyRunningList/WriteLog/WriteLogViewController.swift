//
//  WriteLogViewController.swift
//  Runner-be
//
//  Created by 김창규 on 8/30/24.
//

import UIKit

final class WriteLogViewController: BaseViewController {
    // MARK: - Properties

    private let viewModel: WriteLogViewModel

    // MARK: - UI

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = "2024년 0월 0일 월요일"
        navBar.leftBtnItem.setImage(Asset.x.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.isHidden = true
        navBar.rightSecondBtnItem.isHidden = true
    }

    // MARK: - Init

    init(viewModel: WriteLogViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
    }

    // MARK: - Methods

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .map { true }
            .bind(to: viewModel.routes.backward)
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout

extension WriteLogViewController {
    private func setupViews() {
        setBackgroundColor()
        view.addSubviews([
            navBar,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
    }
}
