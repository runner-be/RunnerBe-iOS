//
//  MessageViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import UIKit

class MessageViewController: BaseViewController
{
    // MARK: Lifecycle

    override init()
    {
        super.init()
        configureTabItem()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .blue
        // Do any additional setup after loading the view.
    }

    // MARK: Private

    private func configureTabItem()
    {
        tabBarItem = UITabBarItem(
            title: "",
            image: Asset.Images.messageTabIconNormal.uiImage,
            selectedImage: Asset.Images.messageTabIconFocused.uiImage
        )
    }
}
