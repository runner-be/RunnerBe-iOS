//
//  MessageViewController.swift
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

class MessageListViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: MessageListViewModel) {
        self.viewModel = viewModel
        super.init()
        configureTabItem()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: MessageListViewModel

    private func viewModelInput() {}
    private func viewModelOutput() {
        // TODO: For Test -> ViewModel과 연결하기
        let items = ["1", "2", "3", "4"]
        let itemsOb = Observable.of(items)
        itemsOb.bind(to: tableView.rx.items) { (tableView: UITableView, _: Int, _: String) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageListItemView.id)
            else { return UITableViewCell() }

            return cell
        }.disposed(by: disposeBags)
    }

    // TODO: For Test
    var numItem = 8

    private lazy var tableView = UITableView().then { view in
        view.estimatedRowHeight = 200
        view.allowsSelection = false
        view.alwaysBounceVertical = false
        view.isScrollEnabled = true
        view.separatorStyle = .singleLine
        view.separatorColor = .darkG5
        view.separatorInset = .zero
        view.backgroundColor = .clear
        view.register(MessageListItemView.self, forCellReuseIdentifier: MessageListItemView.id)
    }

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.font = .iosBody17Sb
        navBar.titleLabel.text = L10n.Home.MessageList.NavBar.title
        navBar.titleLabel.textColor = .darkG35
        navBar.rightBtnItem.setTitle(L10n.Home.MessageList.NavBar.rightItem, for: .normal)
        navBar.rightBtnItem.titleLabel?.font = .iosBody17R
        navBar.rightBtnItem.setTitleColor(.darkG3, for: .normal)
        navBar.rightSecondBtnItem.isHidden = true
    }
}

// MARK: - Layout

extension MessageListViewController {
    private func setupViews() {
        gradientBackground()

        view.addSubviews([
            navBar,
            tableView,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
        }
    }

    private func configureTabItem() {
        tabBarItem = UITabBarItem(
            title: "",
            image: Asset.messageTabIconNormal.uiImage,
            selectedImage: Asset.messageTabIconFocused.uiImage
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
