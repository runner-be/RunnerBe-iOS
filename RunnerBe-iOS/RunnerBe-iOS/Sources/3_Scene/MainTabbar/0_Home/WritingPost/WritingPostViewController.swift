//
//  WritingPostViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/18.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class WritingPostViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: WritingPostViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: WritingPostViewModel

    private func viewModelInput() {}
    private func viewModelOutput() {}

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = ""
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)

        navBar.rightBtnItem.setTitle(L10n.NavBar.Right.First.next, for: .normal)
        navBar.rightBtnItem.setTitleColor(.darkG3, for: .normal)
        navBar.rightBtnItem.titleLabel?.font = .iosBody17R
        navBar.rightSecondBtnItem.isHidden = false
    }

    private var segmentedControl = SegmentedControl().then { control in

        control.defaultTextFont = .iosBody15R
        control.defaultTextColor = .darkG45
        control.highlightTextFont = .iosBody15B
        control.highlightTextColor = .darkG5
        control.boxColors = [.darkG6]
        control.highlightBoxColors = [.segmentBgTop, .segmentBgBot]
        control.highlightBoxPadding = .zero
        control.boxPadding = UIEdgeInsets(top: 6, left: 0, bottom: 8, right: 0)

        control.items = [
            L10n.Post.WorkTime.afterWork,
            L10n.Post.WorkTime.beforeWork,
            L10n.Post.WorkTime.dayOff,
        ]
    }
}

// MARK: - Layout

extension WritingPostViewController {
    private func setupViews() {
        gradientBackground()

        view.addSubviews([
            navBar,
            segmentedControl,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide
                .snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(12)
            make.leading.equalTo(view.snp.leading).offset(14)
            make.trailing.equalTo(view.snp.trailing).offset(-14)
//            make.height.equalTo(32)
        }
    }

    private func gradientBackground() {
        let backgroundGradientLayer = CAGradientLayer()
        backgroundGradientLayer.colors = [
            UIColor.bgBottom.cgColor,
            UIColor.bgTop.cgColor,
        ]
        backgroundGradientLayer.frame = view.bounds
        view.layer.addSublayer(backgroundGradientLayer)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}
