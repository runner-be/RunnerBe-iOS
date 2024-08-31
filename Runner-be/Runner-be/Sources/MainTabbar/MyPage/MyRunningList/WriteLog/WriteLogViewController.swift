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

    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
    }

    private lazy var vStackView = UIStackView.make(
        with: [
            logStampView,
            hDivider1,
            logDiaryView,
            hDivider2,
            privacyToggleView,
            registerButton,
            UIView(),
        ],
        axis: .vertical,
        spacing: 24
    )

    private let logStampView = WriteLogStampView()

    private var hDivider1 = UIView().then {
        $0.backgroundColor = .darkG6
        $0.snp.makeConstraints {
            $0.height.equalTo(1)
        }
    }

    private let logDiaryView = WriteLogDiaryView(type: .write)

    private let hDivider2 = UIView().then {
        $0.backgroundColor = .darkG6
        $0.snp.makeConstraints {
            $0.height.equalTo(1)
        }
    }

    private let privacyToggleView = WriteLogToggleView()

    private let registerButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.setTitleColor(.darkG6, for: .normal)
        $0.titleLabel?.font = UIFont.pretendardSemiBold15
        $0.layer.cornerRadius = 24
        $0.backgroundColor = .primary
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
            scrollView,
        ])

        scrollView.addSubview(vStackView)
    }

    private func initialLayout() {
        navBar.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }

        vStackView.snp.makeConstraints {
//            $0.top.equalToSuperview().inset(24)
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }

        logDiaryView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
        }

        registerButton.snp.makeConstraints {
            $0.height.equalTo(48)
        }

        privacyToggleView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
        }
    }
}
