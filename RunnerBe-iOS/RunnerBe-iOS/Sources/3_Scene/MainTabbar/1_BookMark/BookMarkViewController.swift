//
//  BookMarkViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import UIKit

class BookMarkViewController: BaseViewController {
    // MARK: Lifecycle

    override init() {
        super.init()
        configureTabItem()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        // Do any additional setup after loading the view.
    }

    // MARK: Private

    private func configureTabItem() {
        tabBarItem = UITabBarItem(
            title: "",
            image: Asset.bookmarkTabIconNormal.uiImage,
            selectedImage: Asset.bookmarkTabIconFocused.uiImage
        )
        tabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
    }
}
