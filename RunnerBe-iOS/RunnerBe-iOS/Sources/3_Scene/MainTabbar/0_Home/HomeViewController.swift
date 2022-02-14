//
//  HomeViewController.swift
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

class HomeViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init()
        configureTabItem()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: HomeViewModel

    private func viewModelInput() {}
    private func viewModelOutput() {}
}

// MARK: - Layout

extension HomeViewController {
    private func setupViews() {}

    private func initialLayout() {}

    private func configureTabItem() {
        tabBarItem = UITabBarItem(
            title: "",
            image: Asset.homeTabIconNormal.uiImage,
            selectedImage: Asset.homeTabIconFocused.uiImage
        )
        tabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
    }
}

/*

 */
