//
//  BookMarkViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import UIKit

class BookMarkViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        // Do any additional setup after loading the view.
    }

    override init() {
        super.init()
        configureTabItem()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureTabItem() {
        tabBarItem = UITabBarItem(
            title: "",
            image: Asset.Images.bookmarkTabIconNormal.uiImage,
            selectedImage: Asset.Images.bookmarkTabIconFocused.uiImage
        )
    }
}
