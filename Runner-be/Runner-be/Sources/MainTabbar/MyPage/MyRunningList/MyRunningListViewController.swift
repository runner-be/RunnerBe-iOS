//
//  MyRunningListViewController.swift
//  Runner-be
//
//  Created by 김창규 on 8/29/24.
//

import Foundation

final class MyRunningListViewController: BaseViewController {
    // MARK: - Properties

    private let viewModel: MyRunningListViewModel

    // MARK: - UI

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = "참여한 러닝"
        navBar.leftBtnItem.setImage(Asset.x.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.isHidden = true
        navBar.rightSecondBtnItem.isHidden = true
    }

    // MARK: - Init

    init(viewModel: MyRunningListViewModel) {
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

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.routes.backward)
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout

extension MyRunningListViewController {
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
