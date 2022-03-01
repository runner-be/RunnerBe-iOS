//
//  MainTabbarController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/26.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class MainTabViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: MainTabViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        delegate = self
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: MainTabViewModel

    private func viewModelInput() {}
    private func viewModelOutput() {}

    private var currentTabIndex = 0
}

extension MainTabViewController: UITabBarControllerDelegate {
    override func tabBar(_: UITabBar, didSelect item: UITabBarItem) {
        guard let idx = tabBar.items?.firstIndex(where: { $0 === item })
        else { return }

        if currentTabIndex != idx {
            switch idx {
            case 0:
                viewModel.inputs.homeSelected.onNext(())
            case 1:
                viewModel.inputs.bookMarkSelected.onNext(())
            case 2:
                viewModel.inputs.myPageSelected.onNext(())
            default: break
            }
            currentTabIndex = idx
        }
    }
}