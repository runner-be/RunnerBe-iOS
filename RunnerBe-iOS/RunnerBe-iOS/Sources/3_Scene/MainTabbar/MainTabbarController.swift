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

    private var disposeBag = DisposeBag()
    private var viewModel: MainTabViewModel

    private func viewModelInput() {}
    private func viewModelOutput() {
        viewModel.outputs.home
            .subscribe(onNext: { [weak self] in
                self?.selectedIndex = 0
                self?.viewModel.inputs.homeSelected.onNext(())
            })
            .disposed(by: disposeBag)
    }

    private var currentTabIndex = 0
}

extension MainTabViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect _: UIViewController) {
        let selectedIdx = tabBarController.selectedIndex
        if viewModel.outputs.certificated {
            if currentTabIndex != selectedIdx {
                switch selectedIdx {
                case 0:
                    viewModel.inputs.homeSelected.onNext(())
                case 1:
                    viewModel.inputs.bookMarkSelected.onNext(())
                case 2:
                    viewModel.inputs.myPageSelected.onNext(())
                default: break
                }
            }
        } else {
            selectedIndex = 0
            viewModel.inputs.showOnboardingCover.onNext(())
        }
    }
}
