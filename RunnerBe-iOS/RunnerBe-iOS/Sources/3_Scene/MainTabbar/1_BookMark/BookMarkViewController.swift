//
//  BookMarkViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class BookMarkViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: BookMarkViewModel) {
        self.viewModel = viewModel
        super.init()
        configureTabItem()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: BookMarkViewModel

    private func viewModelInput() {}
    private func viewModelOutput() {}
}

// MARK: - Layout

extension BookMarkViewController {
    private func setupViews() {
        gradientBackground()
    }

    private func initialLayout() {}

    private func configureTabItem() {
        tabBarItem = UITabBarItem(
            title: "",
            image: Asset.bookmarkTabIconNormal.uiImage,
            selectedImage: Asset.bookmarkTabIconFocused.uiImage
        )
        tabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
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
