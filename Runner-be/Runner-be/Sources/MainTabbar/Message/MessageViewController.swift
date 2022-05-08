//
//  MessageViewController.swift
//  Runner-be
//
//  Created by 김신우 on 2022/04/26.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class MessageViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.id)

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: MessageViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: MessageViewModel

    private func viewModelInput() {}
    private func viewModelOutput() {}

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = L10n.MessageList.NavBar.title
        navBar.titleLabel.font = .iosBody17Sb
        navBar.titleLabel.textColor = .darkG35
        navBar.rightBtnItem.setTitle(L10n.MessageList.NavBar.rightItem, for: .normal)
        navBar.rightBtnItem.setTitleColor(.darkG3, for: .normal)
        navBar.rightBtnItem.setTitleColor(.darkG5, for: .highlighted)
        navBar.rightBtnItem.titleLabel?.font = .iosBody17R
        navBar.rightSecondBtnItem.isHidden = true
        navBar.titleSpacing = 12
    }

    private var tableView = UITableView()
}

// MARK: - Layout

extension MessageViewController {
    private func setupViews() {
        setBackgroundColor()

        view.addSubviews([
            navBar,
            tableView,
        ])

        tableView.backgroundColor = .darkG7
        tableView.isUserInteractionEnabled = false //선택시 하이라이트 효과 없애기
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt _: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.id) as? MessageTableViewCell else { return .init() }

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 76
    }
}
