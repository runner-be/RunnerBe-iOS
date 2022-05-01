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
import SwiftUI
import Then
import UIKit

class MainTabViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()

        showSelectedVC(at: 0)
    }

    init(viewModel: MainTabViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: MainTabViewModel

    private func viewModelInput() {
        homeBtn.rx.tap
            .bind(to: viewModel.inputs.homeSelected)
            .disposed(by: disposeBag)

        bookmarkBtn.rx.tap
            .bind(to: viewModel.inputs.bookMarkSelected)
            .disposed(by: disposeBag)

        messageBtn.rx.tap
            .bind(to: viewModel.inputs.messageSelected)
            .disposed(by: disposeBag)

        myPageBtn.rx.tap
            .bind(to: viewModel.inputs.myPageSelected)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        viewModel.outputs.selectScene
            .subscribe(onNext: { [weak self] index in
                self?.tabSelected(at: index)
                self?.showSelectedVC(at: index)
            })
            .disposed(by: disposeBag)
    }

    private func showSelectedVC(at index: Int) {
        guard index < viewControllers.count else { return }

        for (idx, viewController) in viewControllers.enumerated() {
            if idx == index {
                viewController.view.isHidden = false
            } else {
                viewController.view.isHidden = true
            }
        }

        if !mainContentView.subviews.contains(where: { $0 == viewControllers[index].view }) {
            mainContentView.addSubview(viewControllers[index].view)
            viewControllers[index].view.snp.makeConstraints { make in
                make.top.equalTo(mainContentView.snp.top)
                make.leading.equalTo(mainContentView.snp.leading)
                make.trailing.equalTo(mainContentView.snp.trailing)
                make.bottom.equalTo(mainContentView.snp.bottom)
            }
        }
    }

    private func tabSelected(at index: Int) {
        guard index < 4 else { return }

        homeBtn.isSelected = false
        bookmarkBtn.isSelected = false
        messageBtn.isSelected = false
        myPageBtn.isSelected = false

        switch index {
        case 0:
            homeBtn.isSelected = true
        case 1:
            bookmarkBtn.isSelected = true
        case 2:
            messageBtn.isSelected = true
        case 3:
            myPageBtn.isSelected = true
        default:
            break
        }
    }

    var viewControllers: [UIViewController] = []

    private var mainContentView = UIView().then { view in
        view.backgroundColor = .white
    }

    private var bottomView = UIView().then { view in
        view.backgroundColor = .darkG6
    }

    private var homeBtn = UIButton().then { button in
        button.setImage(Asset.homeTabIconNormal.image, for: .normal)
        button.setImage(Asset.homeTabIconFocused.image, for: .selected)
        button.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
    }

    private var bookmarkBtn = UIButton().then { button in
        button.setImage(Asset.bookmarkTabIconNormal.image, for: .normal)
        button.setImage(Asset.bookmarkTabIconFocused.image, for: .selected)
        button.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
    }

    private var messageBtn = UIButton().then { button in
        button.setImage(Asset.messageTabIconNormal.image, for: .normal)
        button.setImage(Asset.messageTabIconFocused.image, for: .selected)
        button.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
    }

    private var myPageBtn = UIButton().then { button in
        button.setImage(Asset.myPageTabIconNormal.image, for: .normal)
        button.setImage(Asset.myPageTabIconFocused.image, for: .selected)
        button.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
    }

    private lazy var bottomContentHStack = UIStackView.make(
        with: [homeBtn, bookmarkBtn, messageBtn, myPageBtn],
        axis: .horizontal,
        alignment: .center,
        distribution: .equalCentering,
        spacing: 0
    )
}

// MARK: - Layout

extension MainTabViewController {
    private func setupViews() {
        homeBtn.isSelected = true

        view.addSubviews([
            mainContentView,
            bottomView,
        ])

        bottomView.addSubviews([bottomContentHStack])
    }

    private func initialLayout() {
        mainContentView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        bottomView.snp.makeConstraints { make in
            make.top.equalTo(mainContentView.snp.bottom)
            make.leading.equalTo(mainContentView.snp.leading)
            make.trailing.equalTo(mainContentView.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
            make.height.equalTo(52 + AppContext.shared.safeAreaInsets.bottom)
        }

        bottomContentHStack.snp.makeConstraints { make in
            make.top.equalTo(bottomView.snp.top).offset(14)
            make.leading.equalTo(bottomView.snp.leading).offset(36)
            make.trailing.equalTo(bottomView.snp.trailing).offset(-36)
        }
    }
}
