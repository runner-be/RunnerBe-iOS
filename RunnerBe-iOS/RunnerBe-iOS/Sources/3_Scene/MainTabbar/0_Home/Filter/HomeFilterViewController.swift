//
//  HomeFilterViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/16.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class HomeFilterViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: HomeFilterViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: HomeFilterViewModel

    private func viewModelInput() {}
    private func viewModelOutput() {}

    private var filterGenderView = FilterGenderView()
    private var hDivider1 = UIView().then { view in
        view.backgroundColor = .darkG6
    }

    private var filterAgeView = FilterAgeView()
    private var hDivider2 = UIView().then { view in
        view.backgroundColor = .darkG6
    }

    private var filterJobView = FilterJobView()
    private var hDivider3 = UIView().then { view in
        view.backgroundColor = .darkG6
    }

    private var filterPlaceView = FilterPlaceView()

    private lazy var vStackView = UIStackView.make(
        with: [
            filterGenderView,
            hDivider1,
            filterAgeView,
            hDivider2,
            filterJobView,
            hDivider3,
            filterPlaceView,
        ],
        axis: .vertical,
        alignment: .fill,
        distribution: .equalSpacing,
        spacing: 27
    )

    private var scrollView = UIScrollView().then { view in
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.alwaysBounceVertical = false
    }

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = L10n.Home.Filter.NavBar.title
        navBar.titleLabel.font = .iosBody17Sb
        navBar.titleLabel.textColor = .darkG35
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.setImage(Asset.refresh.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightSecondBtnItem.isHidden = true
        navBar.leftBtnItem.isHidden = true
    }
}

// MARK: - Layout

extension HomeFilterViewController {
    private func setupViews() {
        gradientBackground()

        view.addSubviews([
            navBar,
            scrollView,
        ])

        scrollView.addSubview(vStackView)
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide
                .snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(12)
            make.leading.equalTo(view.snp.leading).offset(12)
            make.trailing.equalTo(view.snp.trailing).offset(-12)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        vStackView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.bottom.equalTo(scrollView.snp.bottom)
        }

        hDivider1.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(12)
            make.trailing.equalTo(view.snp.trailing).offset(-12)
            make.height.equalTo(1)
        }
        hDivider2.snp.makeConstraints { make in
            make.leading.equalTo(vStackView.snp.leading)
            make.trailing.equalTo(vStackView.snp.trailing)
            make.height.equalTo(1)
        }
        hDivider3.snp.makeConstraints { make in
            make.leading.equalTo(vStackView.snp.leading)
            make.trailing.equalTo(vStackView.snp.trailing)
            make.height.equalTo(1)
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
